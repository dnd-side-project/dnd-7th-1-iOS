//
//  MyDetailMapVC.swift
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

class MyDetailMapVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let mapVC = MiniMapVC()
        .then {
            $0.hideMagnificationBtn()
        }
    
    private let viewModel = MypageVM()
    
    var matrices: [Matrix]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMypageData()
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
        bindAPIErrorAlert(viewModel)
        bindUserData()
    }
    
    override func bindLoading() {
        super.bindLoading()
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.loading(loading: isLoading)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure

extension MyDetailMapVC {
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
    }
}

// MARK: - Layout

extension MyDetailMapVC {
    private func configureLayout() {
        mapVC.view.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension MyDetailMapVC {
    
}

// MARK: - Output

extension MyDetailMapVC {
    private func bindUserData() {
        viewModel.output.userData
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let matrices = self.matrices,
                      let lastBlock = matrices.last else { return }
                self.mapVC.addMyAnnotation(coordinate: Matrix(latitude: lastBlock.latitude,
                                                              longitude: lastBlock.longitude),
                                           profileImageURL: data.profileImageURL)
                self.mapVC.drawMyMapAtOnce(matrices: matrices)
            })
            .disposed(by: disposeBag)
    }
}
