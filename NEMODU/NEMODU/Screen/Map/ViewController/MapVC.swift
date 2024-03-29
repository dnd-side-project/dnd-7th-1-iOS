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
            $0.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0,
                                                           maxCenterCoordinateDistance: Map.cameraZoomRange)
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
    
    private let bag = DisposeBag()
    
    // Map Overlay
    // mine
    var userOverlay = Area()
    var myMatrices = Set<Matrix>()
    var myBlocks = [Block]()
    
    // 일반 친구
    var grayOverlay = Area()
    var grayMatrices = Set<Matrix>()
    var grayBlocks = [Block]()
    
    // 챌린지 색깔별 친구
    var redOverlay = Area()
    var redMatrices = Set<Matrix>()
    var redBlocks = [Block]()
    
    var pinkOverlay = Area()
    var pinkMatrices = Set<Matrix>()
    var pinkBlocks = [Block]()
    
    var yellowOverlay = Area()
    var yellowMatrices = Set<Matrix>()
    var yellowBlocks = [Block]()
    
    // 사용자 위치 이동
    var isFocusOn = true
    
    // 운동 기록
    var blocks: [Matrix] = []
    var blocksCnt = BehaviorRelay<Int>(value: 0)
    var isRecording = BehaviorRelay<Bool>(value: false)
    var isVehicle = BehaviorRelay<Bool>(value: false)
    var updateDistance = BehaviorRelay<Int>(value: 0)
    
    private let activityManager = CMMotionActivityManager()
    private let pedoMeter = CMPedometer()
    private var pauseCnt = 0
    var stepCnt = 0
    
    private var prevLatitude: Int = 0
    private var prevLongitude: Int = 0
    private var previousCoordinate: CLLocationCoordinate2D?
    private var walkDistance: Double = 0
    
    // MARK: - EndRecordingDelegate
    
    weak var endRecordDelegate: EndRecordingDelegate?
    
    // MARK: - Lifecycle
    
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
        bindCurrentLocationBtn()
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
                       delta: Map.defaultZoomScale)
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
    /// 지도 제스쳐 시작 시(스크롤, 줌인/아웃) isFocusOn값을 false로 변경.
    /// 사용자 위치에 따른 화면 추적을 막는 메서드
    private func bindMapGesture() {
        mapView.rx.anyGesture(.pan(), .pinch())
            .when(.began)
            .filter({ _ in self.isFocusOn })
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isFocusOn = false
            })
            .disposed(by: bag)
    }

    /// 현재 위치로 이동 버튼 input 연결 메서드
    private func bindCurrentLocationBtn() {
        currentLocationBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let coordinate = self.locationManager.location?.coordinate else {
                    self.popUpAlert(alertType: .requestLocationAuthority,
                                    targetVC: self,
                                    highlightBtnAction: #selector(self.openSystem),
                                    normalBtnAction: #selector(self.dismissAlert))
                    return
                }
                _ = self.goLocation(latitudeValue: coordinate.latitude,
                                    longitudeValue: coordinate.longitude,
                                    delta: Map.defaultZoomScale)
                
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
    func addMyAnnotation(coordinate: Matrix,
                         profileImageURL: URL?,
                         isHidden: Bool = false) {
        let annotation = MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude + Map.latitudeBlockSize / 2,
                                                                         longitude: coordinate.longitude - Map.longitudeBlockSize / 2))
        annotation.profileImage = .defaultThumbnail
        annotation.isHidden = isHidden

        if let profileImageURL = profileImageURL {
            KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: profileImageURL)) {[weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    annotation.profileImage = data.image
                case .failure(let error):
                    print(error)
                }
                
                self.mapView.addAnnotation(annotation)
            }
        } else {
            mapView.addAnnotation(annotation)
        }
    }
    
    /// 친구 핀을 설치하는 메서드.
    /// isHidden: visible 상태
    /// isEnabled: 마커 선택 가능성
    /// isBorderOn: 테두리 존재 여부
    func addFriendAnnotation(coordinate: Matrix,
                             profileImageURL: URL?,
                             nickname: String,
                             color: UIColor,
                             challengeCnt: Int = 0,
                             isHidden: Bool = false,
                             isEnabled: Bool = false,
                             isBorderOn: Bool = false) {
        let annotation = FriendAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude + Map.latitudeBlockSize / 2,
                                                                             longitude: coordinate.longitude - Map.longitudeBlockSize / 2))
        annotation.title = nickname
        annotation.profileImage = .defaultThumbnail
        annotation.color = color
        annotation.challengeCnt = challengeCnt
        annotation.isHidden = isHidden
        annotation.isEnabled = isEnabled
        annotation.isBorderOn = isBorderOn
        
        if let profileImageURL = profileImageURL {
            KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: profileImageURL)) {[weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    annotation.profileImage = data.image
                case .failure(let error):
                    print(error)
                }
                
                self.mapView.addAnnotation(annotation)
            }
        } else {
            mapView.addAnnotation(annotation)
        }
    }
    
    /// 디바이스의 건강 데이터 추적 권한 상태를 반환하는 메서드.
    /// 권한이 정의되지 않은 상태면 권한 요청
    func requestMotionAuthorization() -> Bool {
        let status = CMMotionActivityManager.authorizationStatus()
        switch status {
        case .notDetermined:
            let today = Date()
            var status = false
            self.activityManager.queryActivityStarting(from: today, to: today, to: OperationQueue.main) { _, error in
                status = error != nil
            }
            return status
        case .restricted, .denied:
            return false
        case .authorized:
            return true
        @unknown default:
            fatalError()
        }
    }
    /**
     사용자 activity를 추적하여 사용자의 운동 상태를 파악하는 메서드.
     자동차 or 자전거에 탄 상태라면 걸음수 측정을 중지하고 알람창 띄우기
     정상 측정 상태라면 걸음수 측정을 다시 시작
     */
    func startActivityUpdates() {
        activityManager.startActivityUpdates(to: OperationQueue.current!) { [weak self] deviceActivity in
            guard let self = self,
                  let deviceActivity = deviceActivity
            else { return }
            
            if deviceActivity.automotive || deviceActivity.cycling {
                self.isVehicle.accept(true)
            }
        }
        
        isVehicle
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isVehicle in
                if isVehicle {
                    Map.alertVehicleWarningLocalNotification()
                    owner.popUpAlert(alertType: .speedWarning,
                                     targetVC: owner,
                                     highlightBtnAction: #selector(owner.restartRecord),
                                     normalBtnAction:#selector(owner.postEndRecording))
                    owner.pedoMeter.stopUpdates()
                    owner.pauseCnt = owner.stepCnt
                } else {
                    owner.startUpdateStep()
                }
            })
            .disposed(by: bag)
    }
    
    /// 기록을 종료하는 메서드
    func endActivityUpdates() {
        activityManager.stopActivityUpdates()
        stopUpdateStep()
    }
    
    /// 사용자의 걸음 수를 측정하는 메서드
    func startUpdateStep() {
        isRecording.accept(true)
        
        pedoMeter.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self else { return }
            if error == nil {
                if let response = data {
                    self.stepCnt = response.numberOfSteps.intValue + self.pauseCnt
                }
            }
        }
    }
    
    /// 사용자 걸음 수 측정을 정지하는 메서드
    func stopUpdateStep() {
        isRecording.accept(false)
        
        pedoMeter.stopUpdates()
        pauseCnt = stepCnt
    }
    
    /// 좌표, 소유자, 색상을 입력받아 네 개의 꼭짓점을 만들어 Block 폴리곤을 반환하는 메서드
    func makeBlocks(matrix: Matrix, owner: BlocksType, color: UIColor) -> Block {
        let longitudeBlockSize = Map.longitudeBlockSize * (matrix.longitude < 0 ? -1 : 1)
        let overlayTopLeftCoordinate = CLLocationCoordinate2D(latitude: matrix.latitude,
                                                              longitude: matrix.longitude + longitudeBlockSize)
        let overlayTopRightCoordinate = CLLocationCoordinate2D(latitude: matrix.latitude,
                                                               longitude: matrix.longitude)
        let overlayBottomLeftCoordinate = CLLocationCoordinate2D(latitude: matrix.latitude + Map.latitudeBlockSize,
                                                                 longitude: matrix.longitude + longitudeBlockSize)
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
    
    /// 영역 배열, 소유자, 색상을 받아 소유자의 영역 Set에 추가하고 기존 overlay를 remove 후 지도에 Area 추가.
    /// 블록 색상에 따른 overlay에 Area 추가.
    func drawBlockArea(matrices: [Matrix], owner: BlocksType, blockColor: UIColor) {
        switch blockColor {
        case ChallengeColorType.green.blockColor:
            update(matrix: &myMatrices,
                   blocks: &myBlocks,
                   overlay: &userOverlay)
        case ChallengeColorType.red.blockColor:
            update(matrix: &redMatrices,
                   blocks: &redBlocks,
                   overlay: &redOverlay)
        case ChallengeColorType.pink.blockColor:
            update(matrix: &pinkMatrices,
                   blocks: &pinkBlocks,
                   overlay: &pinkOverlay)
        case ChallengeColorType.yellow.blockColor:
            update(matrix: &yellowMatrices,
                   blocks: &yellowBlocks,
                   overlay: &yellowOverlay)
        default:
            update(matrix: &grayMatrices,
                   blocks: &grayBlocks,
                   overlay: &grayOverlay)
        }
        
        /// Set<matrix>, [block], overlay를 갱신시키고 overlay(Area)를 remove & add하는 메서드
        func update(matrix: inout Set<Matrix>, blocks: inout [Block], overlay: inout Area) {
            matrices.forEach {
                if !matrix.contains($0) {
                    matrix.insert($0)
                    blocks.append(makeBlocks(matrix: $0,
                                             owner: owner,
                                             color: blockColor))
                }
            }
            mapView.removeOverlay(overlay)
            overlay = Area(blocks)
            overlay.color = blockColor
            mapView.addOverlay(overlay)
        }
    }
    
    
    /// 영역의 소유자를 입력받아 visible 상태를 지정하는 함수
    func setOverlayVisible(of owner: BlocksType, visible: Bool) {
        if owner == .mine {
            visible
            ? mapView.addOverlay(userOverlay)
            : mapView.removeOverlay(userOverlay)
        } else {
            if visible {
                mapView.addOverlay(redOverlay)
                mapView.addOverlay(pinkOverlay)
                mapView.addOverlay(yellowOverlay)
                mapView.addOverlay(grayOverlay)
            } else {
                mapView.removeOverlay(redOverlay)
                mapView.removeOverlay(pinkOverlay)
                mapView.removeOverlay(yellowOverlay)
                mapView.removeOverlay(grayOverlay)
            }
        }
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
        default:
            self.popUpAlert(alertType: .requestLocationAuthority,
                            targetVC: self,
                            highlightBtnAction: #selector(openSystem),
                            normalBtnAction: #selector(dismissAlert))
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
                           delta: Map.defaultZoomScale)
        }
        
        // 기록 중이고
        // 탈것에 타고있지 않고
        // block 경계 이동 시 좌표 판단 및 block overlay 추가
        if isRecording.value && !isVehicle.value && (prevLatitude != latitudeUnit || prevLongitude != longitudeUnit) {
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
        if isRecording.value,
           !isVehicle.value,
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

// MARK: - MKMapViewDelegate

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
            friendBottomSheet.delegate = self
            self.present(friendBottomSheet, animated: true)
        }
    }
}

// MARK: - FriendProfileProtocol

extension MapVC: FriendProfileProtocol {
    /// 선택된 annotation을 모두 deselect 하는 메서드
    func deselectAnnotation() {
        mapView.selectedAnnotations.forEach {
            mapView.deselectAnnotation($0, animated: true)
        }
    }
    
    /// 진행중인 챌린지 상세 화면을 push하는 메서드
    func pushChallengeDetail(_ uuid: String) {
        let challengeDetailVC = ChallengeHistoryDetailVC()
        challengeDetailVC.getChallengeHistoryDetailInfo(uuid: uuid)
        challengeDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(challengeDetailVC, animated: true)
    }
}

// MARK: - EndRecordingDelegate

protocol EndRecordingDelegate: AnyObject {
    func pushRecordResultVC()
}

extension MapVC {
    /// 기록 종료 확인 버튼 이벤트 전달
    @objc func postEndRecording() {
        guard let endRecordDelegate = endRecordDelegate else { return }
        endRecordDelegate.pushRecordResultVC()
    }
    
    /// 탈것 기록 일시정지 - 계속하기 버튼 메서드
    @objc func restartRecord() {
        isVehicle.accept(false)
        dismissAlert()
    }
}
