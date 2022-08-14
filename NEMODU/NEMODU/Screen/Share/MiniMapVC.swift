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
        
        mapView.mapType = .standard
        mapView.showsUserLocation = false
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.layer.cornerRadius = 15
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

extension MiniMapVC {
    
}
