//
//  FriendRecommendSettingVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/24.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class FriendRecommendSettingVC: BaseViewController {
    private let titleLabel = UILabel()
        .then {
            $0.text = "추천 친구 동의"
            $0.font = .title1
            $0.textColor = .gray900
            $0.setLineBreakMode()
        }
    
    private let messageLabel = UILabel()
        .then {
            $0.text = "제외 시 전체 사용자에게 보여지는 추천 친구에서\n내 계정이 표시되지 않습니다. 이후 개인정보 설정에서도\n설정 변경이 가능합니다."
            $0.font = .body3
            $0.textColor = .gray700
            $0.setLineBreakMode()
        }
    
    private let subTitleLabel = UILabel()
        .then {
            $0.text = "친구 추천 목록 제외"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let permissionToggle = UISwitch()
        .then {
            $0.onTintColor = .main
            $0.isOn = true
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindToggleBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension FriendRecommendSettingVC {
    private func configureContentView() {
        view.backgroundColor = .clear
        view.addSubviews([titleLabel,
                          messageLabel,
                          subTitleLabel,
                          permissionToggle])
        
    }
    
    ///
    func setNicknameLabel(_ nickname: String) {
        titleLabel.text = "다른 사용자에게\n\(nickname)님을 추천할까요?"
    }
}

// MARK: - Layout

extension FriendRecommendSettingVC {
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        permissionToggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(subTitleLabel.snp.centerY)
        }
    }
}

// MARK: - Input

extension FriendRecommendSettingVC {
    private func bindToggleBtn() {
        permissionToggle.rx.isOn
            .changed
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                print(status)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension FriendRecommendSettingVC {
    
}
