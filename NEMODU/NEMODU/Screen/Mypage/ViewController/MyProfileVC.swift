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
    
    private let signOutBtn = ArrowBtn(title: "회원 탈퇴")
    
    private let viewModel = UserInfoSettingVM()
    private let bag = DisposeBag()
    
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
        bindProfileData()
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
        
        [editProfileBtn, accountInfoView, logoutBtn, signOutBtn].forEach {
            settingBtnStackView.addArrangedSubview($0)
        }
        settingBtnStackView.addHorizontalSeparators(color: .gray50, height: 1)
    }
    
    private func configureProfileData(_ data: MyProfileResponseModel) {
        // TODO: - options 수정
        profileImageBtn.kf.setImage(with: data.profileImageURL,
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
        
        [editProfileBtn, accountInfoView, logoutBtn, signOutBtn].forEach {
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

// MARK: - Input

extension MyProfileVC {
    private func bindBtn() {
        profileImageBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showProfileImage(with: self.profileImageBtn.currentImage!)
            })
            .disposed(by: bag)
        
        editProfileBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let editProfileVC = EditProfileVC()
                editProfileVC.delegate = self
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            })
            .disposed(by: bag)
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
            .disposed(by: bag)
    }
}

// MARK: - ProfileChanged

extension MyProfileVC: ProfileChanged {
    func popupToastView() {
        popupToast(toastType: .profileChanged)
    }
}
