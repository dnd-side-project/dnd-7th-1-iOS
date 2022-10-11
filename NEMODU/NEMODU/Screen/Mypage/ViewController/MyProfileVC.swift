//
//  MyProfileVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/11.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class MyProfileVC: BaseViewController {
    
    private let naviBar = NavigationBar()
    
    private let profileImageBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "defaultThumbnail"), for: .normal)
            $0.layer.cornerRadius = 48
            $0.clipsToBounds = true
        }
    
    private let nicknameLabel = UILabel()
        .then {
            $0.text = "-"
            $0.font = .title3SB
            $0.textColor = .gray900
            $0.textAlignment = .center
        }
    
    private let profileMessageLabel = UILabel()
        .then {
            $0.font = .body2
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
    
    private let settingBtnStackView = UIStackView()
        .then {
            $0.spacing = 0
            $0.axis = .vertical
            $0.distribution = .equalCentering
        }
    
    private let editProfileBtn = ArrowBtn(title: "프로필 수정")
    
    private let accountInfoBtn = ArrowBtn(title: "계정 정보")
    
    private let logoutBtn = ArrowBtn(title: "로그아웃")
    
    private let signOutBtn = ArrowBtn(title: "회원 탈퇴")
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
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

extension MyProfileVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: "내 프로필")
        naviBar.configureBackBtn(targetVC: self)
    }
    
    private func configureContentView() {
        view.addSubviews([profileImageBtn,
                          nicknameLabel,
                          profileMessageLabel,
                          settingBtnStackView])
        
        [editProfileBtn, accountInfoBtn, logoutBtn, signOutBtn].forEach {
            settingBtnStackView.addArrangedSubview($0)
        }
        settingBtnStackView.addHorizontalSeparators(color: .gray50, height: 1)
    }
}

// MARK: - Layout

extension MyProfileVC {
    private func configureLayout() {
        profileImageBtn.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(40)
            $0.width.height.equalTo(96)
            $0.centerX.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageBtn.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        profileMessageLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        settingBtnStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(227)
        }
        
        [editProfileBtn, accountInfoBtn, logoutBtn, signOutBtn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(56)
            }
        }
    }
}

// MARK: - Input

extension MyProfileVC {
    private func bindBtn() {
        accountInfoBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let myAccountVC = MyAccountVC()
                self.navigationController?.pushViewController(myAccountVC, animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MyProfileVC {
    
}
