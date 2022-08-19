//
//  MiniMapVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/13.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import MapKit

class MiniMapVC: MapVC {
    private let magnificationBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "magnification"), for: .normal)
            $0.addShadow()
        }
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureMiniMap()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
}

// MARK: - Configure

extension MiniMapVC {
    private func configureMiniMap() {
        view.addSubview(magnificationBtn)
        
        isFocusOn = false
        isWalking = false
        
        // configure map as read only
        mapView.mapType = .standard
        mapView.showsUserLocation = false
        mapView.layer.cornerRadius = 15
        isUserInteractionEnabled(false)
    }
    
    /// 영역 전체가 한 눈에 보이게 지도에 그려주는 함수
    func drawMiniMap() {
        let sortedLatitude = blocks.sorted(by: { $0[0] < $1[0] })
        let sortedLongitude = blocks.sorted(by: { $0[1] < $1[1] })
        
        // TODO: - 모든 영역이 보일 수 있도록 delta 값 수정
        _ = goLocation(latitudeValue: sortedLatitude[blocks.count/2][0],
                       longitudeValue: sortedLongitude[blocks.count/2][1],
                       delta: 0.003)
        
        blocks.forEach {
            drawBlock(latitude: $0[0],
                      longitude: $0[1],
                      color: .main30)
        }
    }
    
    /// 영역 전체와 마지막 위치를 지정하는 annotation을 한 눈에 보이게 지도에 그려주는 함수
    func drawDetailMap(latitude: Double, longitude: Double) {
        addMyAnnotation(coordinate: [latitude, longitude],
                        profileImage: UIImage(named: "defaultThumbnail")!)
        drawMiniMap()
    }
    
    func hideMagnificationBtn() {
        magnificationBtn.isHidden = true
    }
}

// MARK: - Layout

extension MiniMapVC {
    private func configureLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        magnificationBtn.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(-16)
            $0.height.width.equalTo(48)
        }
    }
}

// MARK: - Input

extension MiniMapVC {
    private func bindBtn() {
        magnificationBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                // TODO: - 상세 지도 연결
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MiniMapVC {}
