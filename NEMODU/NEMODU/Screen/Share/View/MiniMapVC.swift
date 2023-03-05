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
    
    /// 나의 영역을 기준으로 지도가 한 눈에 보이게 미니맵을 그리는 함수
    func drawMiniMap() {
        let sortedLatitude = blocks.sorted { $0.latitude < $1.latitude}
        let sortedLongitude = blocks.sorted { $0.longitude < $1.longitude}
        
        // 영역이 없는 경우 그냥 return & 그냥 현재 위치의 기본 지도가 뜸
        guard let lastLatitude = sortedLatitude.last,
              let firstLatitude = sortedLatitude.first,
              let lastLongitude = sortedLongitude.last,
              let firstLongitude = sortedLongitude.first else { return }
        
        let spanX = Int((lastLatitude.latitude - firstLatitude.latitude) / latitudeBlockSizePoint)
        let spanY = Int((lastLongitude.longitude - firstLongitude.longitude) / longitudeBlockSizePoint)
        var span = Double(spanX > spanY ? spanX : spanY)
        span = (span + 3) * longitudeBlockSizePoint
        
        _ = goLocation(latitudeValue: sortedLatitude[blocks.count/2].latitude,
                       longitudeValue: sortedLongitude[blocks.count/2].longitude,
                       delta: span)
        
        drawBlockArea(matrices: blocks,
                      owner: .mine,
                      blockColor: .main40)
    }
    
    /// miniMap의 확대 버튼을 숨기는 메서드
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
                let detailMapVC = MyDetailMapVC()
                detailMapVC.getBlocks(blocks: self.blocks)
                self.navigationController?.pushViewController(detailMapVC, animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MiniMapVC {}
