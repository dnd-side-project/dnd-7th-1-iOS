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
import Kingfisher
import KakaoSDKUser

class MyProfileVC: BaseViewController {
    
    private let naviBar = NavigationBar()
    
    private let profileImageBtn = UIButton()
        .then {
            $0.setImage(.defaultThumbnail, for: .normal)
            $0.layer.cornerRadius = 48
            $0.clipsToBounds = true
            $0.imageView?.contentMode = .scaleAspectFill
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
    
    private let accountInfoView = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }
    
    private let accountInfoTitleLabel = UILabel()
        .then {
            $0.text = "계정 정보"
            $0.font = .body1
            $0.textColor = .gray900
            $0.textAlignment = .left
        }
    
    private let accountLabel = UILabel()
        .then {
            $0.text = "-"
            $0.font = .body3
            $0.textColor = .gray600
            $0.textAlignment = .right
        }
    
    private let logoutBtn = ArrowBtn(title: "로그아웃")
    
    private let withdrawalBtn = ArrowBtn(title: "회원 탈퇴")
    
    private let viewModel = UserInfoSettingVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMyProfile()
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
        bindAPIErrorAlert(viewModel)
        bindProfileData()
        bindLogout()
        bindDeleteUser()
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
        
        accountInfoView.addSubviews([accountInfoTitleLabel,
                                     accountLabel])
        
        [editProfileBtn, accountInfoView, logoutBtn, withdrawalBtn].forEach {
            settingBtnStackView.addArrangedSubview($0)
        }
        settingBtnStackView.addHorizontalSeparators(color: .gray50, height: 1)
    }
    
    private func configureProfileData(_ data: MyProfileResponseModel) {
        // TODO: - options 수정
        profileImageBtn.kf.setImage(with: data.picturePathURL,
                                    for: .normal,
                                    placeholder: .defaultThumbnail,
                                    options: [.forceRefresh])
        nicknameLabel.text = data.nickname
        profileMessageLabel.text = data.intro
        accountLabel.text = data.mail
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
        
        [editProfileBtn, accountInfoView, logoutBtn, withdrawalBtn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(56)
            }
        }
        
        accountInfoTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        accountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

extension MyProfileVC {
    /// 로그아웃 확인 버튼 메서드
    @objc func confirmLogout() {
        viewModel.postLogout()
    }
    
    @objc func confirmDeleteUser() {
        viewModel.deleteUser()
    }
}

// MARK: - Input

extension MyProfileVC {
    private func bindBtn() {
        profileImageBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showProfileImage(with: self.profileImageBtn.currentImage!)
            })
            .disposed(by: disposeBag)
        
        editProfileBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let editProfileVC = EditProfileVC()
                editProfileVC.delegate = self
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        logoutBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.popUpAlert(alertType: .logout,
                                targetVC: self,
                                highlightBtnAction: #selector(self.confirmLogout),
                                normalBtnAction: #selector(self.dismissAlert))
            })
            .disposed(by: disposeBag)
        
        withdrawalBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.popUpAlert(alertType: .deleteUser,
                                targetVC: self,
                                highlightBtnAction: #selector(self.confirmDeleteUser),
                                normalBtnAction: #selector(self.dismissAlert))
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension MyProfileVC {
    private func bindProfileData() {
        viewModel.output.myProfile
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.configureProfileData(data)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLogout() {
        viewModel.output.isLogout
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if UserDefaults.standard.string(forKey: UserDefaults.Keys.loginType) == LoginType.kakao.rawValue {
                    UserApi.shared.logout { error in
                        self.removeUserData()
                        self.setLoginToRootVC()
                    }
                } else {
                    self.removeUserData()
                    self.setLoginToRootVC()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDeleteUser() {
        viewModel.output.isDeleted
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.removeUserData()
                self.setLoginToRootVC()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ProfileChanged

extension MyProfileVC: ProfileChanged {
    func popupToastView() {
        popupToast(toastType: .profileChanged)
    }
}
