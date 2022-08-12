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

class MiniMapVC: BaseViewController {
    private var miniMap = MKMapView()
        .then {
            $0.mapType = .standard
            $0.showsUserLocation = false
            $0.isZoomEnabled = false
            $0.isScrollEnabled = false
            $0.layer.cornerRadius = 15
        }
    
    private let zoomInBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "pause"), for: .normal)
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
        view.addSubviews([miniMap, zoomInBtn])
    }
}

// MARK: - Layout

extension MiniMapVC {
    private func configureLayout() {
        miniMap.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        zoomInBtn.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(-16)
            $0.height.width.equalTo(48)
        }
    }
}

// MARK: - Input

extension MiniMapVC {
    private func bindBtn() {
        zoomInBtn.rx.tap
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
