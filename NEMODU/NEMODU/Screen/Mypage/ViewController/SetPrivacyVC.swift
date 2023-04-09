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
    
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        configureNavigationBar()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindButton()
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
                print("친구목록제외 isOn changed: \(status)") // TODO: - 친구목록제외 여부 설정 서버연결
            })
            .disposed(by: bag)
    }
    
}
