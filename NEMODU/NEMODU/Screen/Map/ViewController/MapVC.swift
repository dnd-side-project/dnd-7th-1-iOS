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
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    var stepCnt = 0
    var pauseCnt = 0

    let blockSizePoint: Double = 0.0003740
    private let blockSize: Int = 37400
    private let mapZoomScale = 0.003
    private let mul: Double = 100000000
    private let bag = DisposeBag()
    
    private var prevLatitude: Int = 0
    private var prevLongitude: Int = 0
    private var previousCoordinate: CLLocationCoordinate2D?
    private var walkDistance: Double = 0
    
    var isFocusOn = true
    var isWalking: Bool?
    var blocks: [[Double]] = []
    var blockColor: UIColor = .main
    var blocksCnt = BehaviorRelay<Int>(value: 0)
    var updateDistance = BehaviorRelay<Int>(value: 0)
    
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
        view.addSubview(mapView)
        locationManager.delegate = self
        mapView.delegate = self
        
        // 현재 위치로 이동
        _ = goLocation(latitudeValue: locationManager.location?.coordinate.latitude ?? 0,
                       longitudeValue: locationManager.location?.coordinate.longitude ?? 0,
                       delta: mapZoomScale)
        
        // 버튼
        view.addSubview(currentLocationBtn)
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
                                    delta: self.mapZoomScale)
                
                // 사용자 추적 On
                self.isFocusOn = true
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MapVC {
    
}

// MARK: - Custom Methods

extension MapVC {
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
                } else if deviceActivity.automotive {
                    print("자동차!")
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
    
    /// 특정 좌표에 블록을 그리는 함수
    func drawBlock(latitude: Double, longitude: Double) {
        let latPoint = Int(latitude * mul) / blockSize
        let longPoint = Int(longitude * mul) / blockSize
        
        // TODO: - 백엔드와 회의 후 클래스화 진행
        let overlayTopLeftCoordinate = CLLocationCoordinate2D(latitude: Double((latPoint) * blockSize) / mul,
                                                              longitude: Double((longPoint - 1) * blockSize) / mul)
        let overlayTopRightCoordinate = CLLocationCoordinate2D(latitude: Double((latPoint) * blockSize) / mul,
                                                               longitude: Double((longPoint) * blockSize) / mul)
        let overlayBottomLeftCoordinate = CLLocationCoordinate2D(latitude: Double((latPoint + 1) * blockSize) / mul,
                                                                 longitude: Double((longPoint - 1) * blockSize) / mul)
        let overlayBottomRightCoordinate = CLLocationCoordinate2D(latitude: Double((latPoint + 1) * blockSize) / mul,
                                                                  longitude: Double((longPoint) * blockSize) / mul)
        
        let blockDraw = MKPolygon(coordinates: [overlayTopLeftCoordinate,
                                                overlayTopRightCoordinate,
                                                overlayBottomRightCoordinate,
                                                overlayBottomLeftCoordinate], count: 4)
        
        mapView.addOverlay(blockDraw)
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
    
    /// 내 핀을 설치하는 함수
    func addMyAnnotation(coordinate: [Double], profileImage: UIImage) {
        let annotation = MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0],
                                                                         longitude: coordinate[1]))
        annotation.profileImage = profileImage
        mapView.addAnnotation(annotation)
    }
    
    /// 친구 핀을 설치하는 함수
    func addFriendAnnotation(coordinate: [Double], profileImage: UIImage, nickname: String, color: UIColor, challengeCnt: Int) {
        let annotation = FriendAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0],
                                                                             longitude: coordinate[1]))
        annotation.title = nickname
        annotation.profileImage = profileImage
        annotation.color = color
        annotation.challengeCnt = challengeCnt
        mapView.addAnnotation(annotation)
    }
    
    /// 사용자 위치 이동 시 처리 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // 실제 위치 좌표
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let latPoint = Int(latitude * mul) / blockSize
        let longPoint = Int(longitude * mul) / blockSize
        
        // 사용자 이동에 맞춰 화면 이동
        if isFocusOn {
            _ = goLocation(latitudeValue: latitude,
                           longitudeValue: longitude,
                           delta: mapZoomScale)
        }
        
        // 기록 중이고
        // block 경계 이동 시 좌표 판단 및 block overlay 추가
        if (isWalking ?? false) && (prevLatitude != latPoint || prevLongitude != longPoint) {
            prevLatitude = latPoint
            prevLongitude = longPoint
            
            if !blocks.contains([Double((latPoint) * blockSize) / mul, Double((longPoint) * blockSize) / mul]) {
                // block Point 저장
                blocks.append([Double((latPoint) * blockSize) / mul, Double((longPoint) * blockSize) / mul])
                
                drawBlock(latitude: latitude, longitude: longitude)

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
    /// 사용자 땅을 칠하는 함수
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let block = MKPolygonRenderer(overlay: overlay)
            block.fillColor = blockColor
            block.alpha = 0.5
            return block
        } else {
            // TODO: - Alert 띄우기
            print("영역을 그릴 수 없습니다")
            return MKOverlayRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? FriendAnnotation {
            annotationView = setupFriendAnnotationView(for: annotation, on: mapView)
        } else if let annotation = annotation as? MyAnnotation {
            annotationView = setupMyAnnotationView(for: annotation, on: mapView)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view as? FriendAnnotationView {
            annotation.setSelected(true, animated: true)
            
            let friendBottomSheet = FriendProfileBottomSheet()
            self.present(friendBottomSheet, animated: true)
        }
    }
}
