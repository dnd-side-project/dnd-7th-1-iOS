//
//  MapVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import MapKit
import CoreLocation
import CoreMotion
import Lottie
import Kingfisher

class MapVC: BaseViewController {
    var mapView = MKMapView()
        .then {
            $0.mapType = .standard
            $0.setUserTrackingMode(.followWithHeading, animated: true)
            $0.showsUserLocation = true
            $0.isZoomEnabled = true
            $0.showsTraffic = false
        }
    
    var locationManager = CLLocationManager()
        .then {
            $0.desiredAccuracy = kCLLocationAccuracyBest
            $0.allowsBackgroundLocationUpdates = true
            $0.requestAlwaysAuthorization()
            $0.startUpdatingLocation()
            $0.activityType = .fitness
        }
    
    var currentLocationBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "location"), for: .normal)
            $0.addShadow()
        }
    
    let animationView = AnimationView(name: "concentricCircles")
        .then {
            $0.loopMode = .loop
            $0.contentMode = .scaleToFill
        }

    let userLocationView = UIView()
        .then {
            $0.backgroundColor = .userLocation
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 4
            $0.layer.borderColor = UIColor.white.cgColor
        }
    
    private let activityManager = CMMotionActivityManager()
    private let pedoMeter = CMPedometer()
    private var pauseCnt = 0
    var stepCnt = 0
    
    private let bag = DisposeBag()
    
    private var prevLatitude: Int = 0
    private var prevLongitude: Int = 0
    private var previousCoordinate: CLLocationCoordinate2D?
    private var walkDistance: Double = 0
    
    var isFocusOn = true
    var isWalking: Bool?
    var updateDistance = BehaviorRelay<Int>(value: 0)
    
    var userOverlay = [Block]()
    var friendsOverlay = [Block]()
    var myMatrices = Set<Matrix>()
    var friendsMatrices = Set<Matrix>()
    var blocks: [Matrix] = []
    var blocksCnt = BehaviorRelay<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureMap()
        registerMapAnnotationViews()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindMapGesture()
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
    /// 메모리 경고를 수신할 경우 뷰 컨트롤러로 전송
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Configure

extension MapVC {
    private func configureMap() {
        view.addSubviews([mapView,
                          currentLocationBtn])
        locationManager.delegate = self
        mapView.delegate = self
        
        // 현재 위치로 이동
        _ = goLocation(latitudeValue: locationManager.location?.coordinate.latitude ?? 0,
                       longitudeValue: locationManager.location?.coordinate.longitude ?? 0,
                       delta: Map.defalutZoomScale)
    }
    
    private func registerMapAnnotationViews() {
        mapView.register(FriendAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: NSStringFromClass(FriendAnnotation.self))
        mapView.register(MyAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: NSStringFromClass(MyAnnotation.self))
    }
    
    private func setupFriendAnnotationView(for annotation: FriendAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(FriendAnnotation.self), for: annotation)
    }
    
    private func setupMyAnnotationView(for annotation: MyAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(MyAnnotation.self), for: annotation)
    }
    
    func isUserInteractionEnabled(_ isEnabled: Bool) {
        mapView.isZoomEnabled = isEnabled
        mapView.isScrollEnabled = isEnabled
        mapView.isRotateEnabled = isEnabled
        mapView.isUserInteractionEnabled = isEnabled
    }
    
    func setUserLocationAnimation(visible: Bool) {
        visible
        ? animationView.play()
        : animationView.removeFromSuperview()
    }
}

// MARK: - Layout

extension MapVC {
    private func configureLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Input

extension MapVC {
    private func bindMapGesture() {
        mapView.rx.anyGesture(.pan(), .pinch())
            .when(.began)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isFocusOn = false
            })
            .disposed(by: bag)
    }
    
    private func bindBtn() {
        // 현재 위치로 이동 버튼
        currentLocationBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let coordinate = self.locationManager.location?.coordinate else { return }
                _ = self.goLocation(latitudeValue: coordinate.latitude,
                                    longitudeValue: coordinate.longitude,
                                    delta: Map.defalutZoomScale)
                
                // 사용자 추적 On
                self.isFocusOn = true
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MapVC {}

// MARK: - Custom Methods

extension MapVC {
    /// 위도, 경도, 스팬(영역 폭)을 입력받아 지도에 표시
    func goLocation(latitudeValue: CLLocationDegrees,
                    longitudeValue: CLLocationDegrees,
                    delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapView.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    /// 내 핀을 설치하는 메서드
    func addMyAnnotation(coordinate: [Double], profileImageURL: URL) {
        KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: profileImageURL)) { result in
            var profileImage = UIImage.defaultThumbnail
            
            switch result {
            case .success(let data):
                profileImage = data.image
            case .failure(let error):
                print(error)
            }
            
            let annotation = MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0] + Map.latitudeBlockSize / 2,
                                                                             longitude: coordinate[1] - Map.longitudeBlockSize / 2))
            annotation.profileImage = profileImage
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    /// 친구 핀을 설치하는 메서드.
    /// isEnabled: 마커 선택 가능성
    /// isBorderOn: 테두리 존재 여부
    func addFriendAnnotation(coordinate: [Double],
                             profileImageURL: URL,
                             nickname: String,
                             color: UIColor,
                             challengeCnt: Int = 0,
                             isEnabled: Bool = false,
                             isBorderOn: Bool = false) {
        KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: profileImageURL)) { result in
            var profileImage = UIImage.defaultThumbnail
            
            switch result {
            case .success(let data):
                profileImage = data.image
            case .failure(let error):
                print(error)
            }
         
            let annotation = FriendAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0] + Map.latitudeBlockSize / 2,
                                                                                 longitude: coordinate[1] - Map.longitudeBlockSize / 2))
            annotation.title = nickname
            annotation.profileImage = profileImage
            annotation.color = color
            annotation.challengeCnt = challengeCnt
            annotation.isEnabled = isEnabled
            annotation.isBorderOn = isBorderOn
            self.mapView.addAnnotation(annotation)
        }
    }
    
    /// 사용자 activity를 추적하여 운동 상태와 걸음 수를 측정하는 함수
    func updateStep() {
        // TODO: - 자동차 or 자전거 사용 시 알람 정책 정한 후 수정
        activityManager.startActivityUpdates(
            to: OperationQueue.current!,
            withHandler: {(
                deviceActivity: CMMotionActivity!
            ) -> Void in
                if deviceActivity.stationary {
                    print("정지중!")
                } else if deviceActivity.walking {
                    print("걷는중!")
                } else if deviceActivity.running {
                    print("뛰는중!")
                } else if deviceActivity.cycling || deviceActivity.automotive {
                    print("자전거 or 자동차!")
                    self.popUpAlert(alertType: .speedWarning,
                                    targetVC: self,
                                    highlightBtnAction: #selector(self.dismissAlert),
                                    normalBtnAction: nil)
                }
            }
        )
        
        pedoMeter.startUpdates(from: Date()) { data, error in
            if error == nil {
                if let response = data {
                    self.stepCnt = response.numberOfSteps.intValue + self.pauseCnt
                }
            }
        }
    }
    
    /// update를 중지하는 함수
    func stopUpdateStep() {
        activityManager.stopActivityUpdates()
        pedoMeter.stopUpdates()
        pauseCnt = stepCnt
    }
    
    /// 좌표, 소유자, 색상을 입력받아 네 개의 꼭짓점을 만들어 Block 폴리곤을 반환하는 메서드
    func makeBlocks(matrix: Matrix, owner: BlocksType, color: UIColor) -> Block {
        let overlayTopLeftCoordinate = CLLocationCoordinate2D(latitude: matrix.latitude,
                                                              longitude: matrix.longitude - Map.longitudeBlockSize)
        let overlayTopRightCoordinate = CLLocationCoordinate2D(latitude: matrix.latitude,
                                                               longitude: matrix.longitude)
        let overlayBottomLeftCoordinate = CLLocationCoordinate2D(latitude: matrix.latitude + Map.latitudeBlockSize,
                                                                 longitude: matrix.longitude - Map.longitudeBlockSize)
        let overlayBottomRightCoordinate = CLLocationCoordinate2D(latitude: matrix.latitude + Map.latitudeBlockSize,
                                                                  longitude: matrix.longitude)
        
        return Block(coordinate: [overlayTopLeftCoordinate,
                                  overlayTopRightCoordinate,
                                  overlayBottomRightCoordinate,
                                  overlayBottomLeftCoordinate],
                     count: 4,
                     owner: owner,
                     color: color)
    }
    
    /// 운동 기록 중 기준 처리된 좌표를 입력받고 해당 위치에 블록을 그리는 메서드로 영역 하나만 그린다.
    func drawMyBlock(matrix: Matrix) {
        mapView.addOverlay(makeBlocks(matrix: matrix,
                                      owner: .mine,
                                      color: .main80))
    }
    
    /// 영역 배열, 소유자, 색상을 받아 소유자의 영역 Set에 추가하고 overlay를 추가하는 메서드로 영역 전체를 그린다.
    /// 중복을 확인하고 탐색 횟수를 줄이기 위해 Matrix를 저장하는 영역 집합(Set)에서 contains 여부를 확인하고 새로 추가된 데이터만 overlay에 추가한다.
    /// 이미 추가된 overlay는 지워지지 않고 새로 받아오는 영역 값만 overlay에 추가된다.
    func drawBlockArea(matrices: [Matrix], owner: BlocksType, blockColor: UIColor) {
        let newBlocks = owner == .mine
        ? appendMatrix(&myMatrices)
        : appendMatrix(&friendsMatrices)
        
        owner == .mine
        ? (userOverlay += newBlocks)
        : (friendsOverlay += newBlocks)
        
        mapView.addOverlays(newBlocks)
        
        /// 중복 영역인지 확인하고 아니라면 사용자 영역에 추가한다.
        /// 추가할 영역(Block)을 return 한다.
        func appendMatrix(_ userMatrices: inout Set<Matrix>) -> [Block] {
            var blocks = [Block]()
            matrices.forEach {
                if !userMatrices.contains($0) {
                    userMatrices.insert($0)
                    blocks.append(makeBlocks(matrix: $0,
                                                owner: owner,
                                                color: blockColor))
                }
            }
            return blocks
        }
    }
    
    /// 영역의 소유자를 입력받아 visible 상태를 지정하는 함수
    func setOverlayVisible(of owner: BlocksType, visible: Bool) {
        visible
        ? mapView.addOverlays(owner == .mine ? userOverlay : friendsOverlay)
        : mapView.removeOverlays(owner == .mine ? userOverlay : friendsOverlay)
    }
    
    /// 내 annotation의 visible 상태를 지정하는 함수
    func setMyAnnotation(visible: Bool) {
        mapView.annotations.forEach {
            if $0 is MyAnnotation {
                if let annotationView = mapView.view(for: $0) {
                    annotationView.isHidden = !visible
                    annotationView.alpha = visible ? 1 : 0
                }
            }
        }
    }
    
    /// 친구들의 annotation의 visible 상태를 지정하는 함수
    func setFriendsAnnotation(visible: Bool) {
        mapView.annotations.forEach {
            if $0 is FriendAnnotation {
                if let annotationView = mapView.view(for: $0) {
                    annotationView.isHidden = !visible
                    annotationView.alpha = visible ? 1 : 0
                }
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapVC: CLLocationManagerDelegate {
    /// 위치 사용 권한 확인
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .denied:
            print("GPS 권한 요청 거부됨")
            // TODO: - 알람창 띄우기
        default:
            print("GPS: Default")
        }
    }
    
    /// 사용자 위치 이동 시 처리 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // 실제 위치 좌표
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // 영역 이동 판단을 위한 단위값
        let latitudeUnit = Int(latitude * Map.mul) / Map.latitudeBlockMultipleSize
        let longitudeUnit = Int(longitude * Map.mul) / Map.longitudeBlockMultipleSize
        
        // 사용자 이동에 맞춰 화면 이동
        if isFocusOn {
            _ = goLocation(latitudeValue: latitude,
                           longitudeValue: longitude,
                           delta: Map.defalutZoomScale)
        }
        
        // 기록 중이고
        // block 경계 이동 시 좌표 판단 및 block overlay 추가
        if (isWalking ?? false) && (prevLatitude != latitudeUnit || prevLongitude != longitudeUnit) {
            prevLatitude = latitudeUnit
            prevLongitude = longitudeUnit
            
            // 실제 저장되고 그려지는 기준 좌표값
            let point = Matrix(latitude: Double((latitudeUnit) * Map.latitudeBlockMultipleSize) / Map.mul,
                               longitude: Double((longitudeUnit) * Map.longitudeBlockMultipleSize) / Map.mul)
            if !blocks.contains(point) {
                // block Point 저장
                blocks.append(point)
                
                drawMyBlock(matrix: point)
                
                blocksCnt.accept(blocks.count)
            }
        }
        
        // 이동 거리 계산
        if (isWalking ?? false),
           let previousCoordinate = self.previousCoordinate {
            let prevPoint = CLLocation(latitude: previousCoordinate.latitude,
                                       longitude: previousCoordinate.longitude)
            let lastPoint = CLLocation(latitude: latitude,
                                       longitude: longitude)
            walkDistance += prevPoint.distance(from: lastPoint)
            updateDistance.accept(Int(floor(walkDistance)))
        }
        self.previousCoordinate = location.coordinate
    }
}

extension MapVC: MKMapViewDelegate {
    /// 사용자 땅을 칠하는 함수 /
    /// 운동 기록 - Block: MKPolygon /
    /// 영역 기록(덩어리) - Area: MKMultiPolygon /
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer: MKOverlayPathRenderer
        
        if let block = overlay as? Block {
            renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = block.color
        } else if let area = overlay as? Area {
            renderer = MKMultiPolygonRenderer(overlay: overlay)
            renderer.fillColor = area.color
        } else {
            print("영역을 그릴 수 없습니다")
            return MKOverlayRenderer()
        }
        
        return renderer
    }
    
    /// custom annotationView를 반환하는 함수
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = nil
            pin.addSubview(animationView)
            animationView.addSubview(userLocationView)
            animationView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.height.equalTo(120)
            }
            userLocationView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.height.equalTo(30)
            }
            
            return pin
        } else {
            var annotationView: MKAnnotationView?
            
            if let annotation = annotation as? FriendAnnotation {
                annotationView = setupFriendAnnotationView(for: annotation, on: mapView)
            } else if let annotation = annotation as? MyAnnotation {
                annotationView = setupMyAnnotationView(for: annotation, on: mapView)
            }
            
            return annotationView
        }
    }
    
    /// annotation을 select 했을때 나타나는 이벤트를 지정하는 함수
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view as? FriendAnnotationView {
            annotation.setSelected(true, animated: true)
            
            let friendBottomSheet = FriendProfileBottomSheet()
            friendBottomSheet.nickname = annotation.nickname.text
            self.present(friendBottomSheet, animated: true)
        }
    }
}
