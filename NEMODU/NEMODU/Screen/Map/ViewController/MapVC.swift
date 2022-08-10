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
            $0.backgroundColor = UIColor.blue
            $0.setTitle("L", for: .normal)
        }
    
    private let mapZoomScale = 0.003
    private let blockSize: Int = 37400
    private let mul: Double = 100000000
    private let bag = DisposeBag()
    
    private var isFocusOn = true
    private var prevLatitude: Int = 0
    private var prevLongitude: Int = 0
    private var previousCoordinate: CLLocationCoordinate2D?
    private var walkDistance: Double = 0
    var isWalking: Bool?
    var blocks: [[Double]] = []
    var blocksCnt = BehaviorRelay<Int>(value: 0)
    var updateDistance = BehaviorRelay<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureMap()
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
                       longtudeValue: locationManager.location?.coordinate.longitude ?? 0,
                       delta: mapZoomScale)
        
        // 버튼
        view.addSubview(currentLocationBtn)
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
    func bindMapGesture() {
        mapView.rx.anyGesture(.pan(), .pinch())
            .when(.began)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isFocusOn = false
            })
            .disposed(by: bag)
    }
    
    func bindBtn() {
        // 현재 위치로 이동 버튼
        currentLocationBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                let coordinate = self.locationManager.location?.coordinate else { return }
                _ = self.goLocation(latitudeValue: coordinate.latitude,
                                    longtudeValue: coordinate.longitude,
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
                    longtudeValue: CLLocationDegrees,
                    delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapView.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    /// 특정 위도와 경도에 핀 설치하고 핀에 타이틀과 서브 타이틀의 문자열 표시
    func setAnnotation(latitudeValue: CLLocationDegrees,
                       longitudeValue: CLLocationDegrees,
                       delta span: Double,
                       title strTitle: String,
                       subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue,
                                           longtudeValue: longitudeValue,
                                           delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        mapView.addAnnotation(annotation)
    }
    
    /// 사용자 위치 이동 시 처리 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let latPoint = Int(latitude * mul) / blockSize
        let longPoint = Int(longitude * mul) / blockSize
        
        // 사용자 이동에 맞춰 화면 이동
        if isFocusOn {
            _ = goLocation(latitudeValue: latitude,
                           longtudeValue: longitude,
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
            block.fillColor = .main
            block.alpha = 0.5
            return block
        } else {
            // TODO: - Alert 띄우기
            print("영역을 그릴 수 없습니다")
            return MKOverlayRenderer()
        }
    }
}
