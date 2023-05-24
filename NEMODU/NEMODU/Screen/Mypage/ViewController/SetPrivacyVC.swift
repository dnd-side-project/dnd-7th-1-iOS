//
//  SetPrivacyVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/08.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SetPrivacyVC: BaseViewController {
    
    // MARK: - UI components
    
    private let navigationBar = NavigationBar()
    
    private let accountPrivacyBoundsTitleLabelView = SettingItemTitleLabelView()
        .then {
            $0.setTitle(settingItemTitle: "계정 공개 범위")
        }
    private let exceptFriendRecommendListToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("친구 추천 목록 제외")
            $0.setMessage("전체 사용자에게 보여지는 추천친구에서\n내 계정이 표시되지않습니다")
        }
    
    // MARK: - Variables and Properties
    
    let viewModel = SetPrivacyVM()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
        getUserPrivacySetting()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindAPIErrorAlert(viewModel)
        bindUserPrivacySetting()
    }
    
}

// MARK: - Configure

extension SetPrivacyVC {
    
    private func configureNavigationBar() {
        navigationBar.naviType = .push
        navigationBar.configureNaviBar(targetVC: self,
                                 title: "개인정보 설정")
        navigationBar.configureBackBtn(targetVC: self)
    }
    
    private func getUserPrivacySetting() {
        viewModel.getUserPrivacySetting()
    }
    
    private func setUserPrivacySetting(userSetting: SetPrivacyResponseModel) {
        exceptFriendRecommendListToggleButtonView.toggleBtn.isOn = userSetting.value
    }
    
}

// MARK: - Layout

extension SetPrivacyVC {
    
    private func configureLayout() {
        view.addSubviews([accountPrivacyBoundsTitleLabelView,
                          exceptFriendRecommendListToggleButtonView])
        
        accountPrivacyBoundsTitleLabelView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view)
        }
        exceptFriendRecommendListToggleButtonView.snp.makeConstraints {
            $0.top.equalTo(accountPrivacyBoundsTitleLabelView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(view).inset(16.0)
        }
    }
    
}

// MARK: - Input

extension SetPrivacyVC {
    
    private func bindButton() {
        exceptFriendRecommendListToggleButtonView.toggleBtn.rx.isOn
            .changed
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                owner.viewModel.updateUserPrivacySetting()
            })
            .disposed(by: disposeBag)
    }
    
}


// MARK: - Output

extension SetPrivacyVC {
    
    private func bindUserPrivacySetting() {
        viewModel.output.userPrivacySetting
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.setUserPrivacySetting(userSetting: data)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isSuccessUpdatePrivacySetting
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.exceptFriendRecommendListToggleButtonView.toggleBtn.isOn = data
            })
            .disposed(by: disposeBag)
    }
    
}
