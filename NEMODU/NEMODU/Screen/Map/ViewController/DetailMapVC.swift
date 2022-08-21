//
//  DetailMapVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/19.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class DetailMapVC: BaseViewController {
    private let naviBar = NavigationBar()

    private let mapVC = MiniMapVC()
        .then {
            $0.hideMagnificationBtn()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureMap()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension DetailMapVC {
    private func configureNaviBar() {
        view.addSubview(naviBar)
        naviBar.backgroundColor = .white
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: "상세 지도")
        naviBar.configureBackBtn(targetVC: self)
    }

    private func configureMap() {
        addChild(mapVC)
        view.addSubview(mapVC.view)
        mapVC.mapView.layer.cornerRadius = 0
        mapVC.isUserInteractionEnabled(true)
        
        guard let lastBlock = mapVC.blocks.last else { return }
        mapVC.drawDetailMap(latitude: lastBlock[0],
                            longitude: lastBlock[1])
    }
    
    func getBlocks(blocks: [[Double]]) {
        mapVC.blocks = blocks
    }
}

// MARK: - Layout

extension DetailMapVC {
    private func configureLayout() {
        mapVC.view.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension DetailMapVC {
    
}

// MARK: - Output

extension DetailMapVC {
    
}
