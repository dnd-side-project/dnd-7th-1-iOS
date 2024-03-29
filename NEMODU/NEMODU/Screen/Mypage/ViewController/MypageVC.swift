//
//  MypageVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/29.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Kingfisher
import SafariServices
import MessageUI

class MypageVC: BaseViewController {
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }
    
    private let dataView = UIView()
    
    private let separatorView = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    private let btnView = UIView()
    
    private let profileView = ProfileView()
    
    private let blockCntView = BlockCntView()
    
    private let recordView = RecordStackView()
        .then {
            $0.configureStackViewTitle(title: "이번주 기록")
            $0.firstView.recordTitle.text = "영역"
            $0.secondView.recordTitle.text = "걸음수"
            $0.thirdView.recordTitle.text = "거리"
            $0.firstView.recordValue.text = "- 칸"
            $0.secondView.recordValue.text = "-"
            $0.thirdView.recordValue.text = "- m"
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 8
        }
    
    private let friendBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "friendsList"), for: .normal)
            $0.setTitle("친구 -명", for: .normal)
        }
    
    private let myRecordBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "myRecordList"), for: .normal)
            $0.setTitle("나의 활동 기록", for: .normal)
        }
    
    private let settingBtnStackView = UIStackView()
        .then {
            $0.spacing = 0
            $0.axis = .vertical
            $0.distribution = .equalCentering
        }
    
    private let setLocationBtn = ArrowBtn(title: "위치 정보 동의 설정")
    
    private let setPrivacyBtn = ArrowBtn(title: "개인 정보 설정")
    
    private let setAlarmBtn = ArrowBtn(title: "알림 설정")
    
    private let termsBtn = ArrowBtn(title: "이용 약관")
    
    private let inquiryBtn = ArrowBtn(title: "문의하기")
    
    private let naviBar = NavigationBar()
    
    private let viewModel = MypageVM()
    
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
        configureMypage()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindBtn()
        bindProfileTap()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindUserData()
        bindAPIErrorAlert(viewModel)
    }
    
}

// MARK: - Configure

extension MypageVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self,
                                 title: "마이페이지")
        naviBar.configureRightBarBtn(targetVC: self,
                                     image: UIImage(named: "bell")!)
    }
    
    private func configureMypage() {
        view.addSubview(baseScrollView)
        baseScrollView.addSubviews([dataView,
                                    separatorView,
                                    btnView])
        dataView.addSubviews([profileView,
                              blockCntView,
                              recordView])
        btnView.addSubviews([friendBtn,
                             myRecordBtn,
                             settingBtnStackView])
        [friendBtn, myRecordBtn].forEach {
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.layer.cornerRadius = 8
            $0.setTitleColor(.gray900, for: .normal)
            $0.titleLabel?.font = .body4
            $0.centerVertically(spacing: 4)
            $0.setBackgroundColor(.gray50, for: .highlighted)
        }
        
        [setLocationBtn, setPrivacyBtn, setAlarmBtn, termsBtn, inquiryBtn].forEach {
            settingBtnStackView.addArrangedSubview($0)
        }
        settingBtnStackView.addHorizontalSeparators(color: .gray50, height: 1)
    }
    
    private func configureUserData(_ userData: MypageUserDataResponseModel) {
        profileView.profileImage.kf.setImage(with: userData.picturePathURL,
                                             placeholder: UIImage.defaultThumbnail)
        profileView.nickname.text = userData.nickname
        if let intro = userData.intro { profileView.profileMessage.text = intro }
        blockCntView.configureBlockCnt(userData.allMatrixNumber.insertComma)
        recordView.firstView.recordValue.text = "\(userData.matrixNumber.insertComma) 칸"
        recordView.secondView.recordValue.text = "\(userData.stepCount.insertComma)"
        recordView.thirdView.recordValue.text = "\(userData.distance.toKilometer)"
        friendBtn.setTitle("친구 \(userData.friendNumber.insertComma)명", for: .normal)
    }
}

// MARK: - Layout

extension MypageVC {
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        dataView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(307)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(dataView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        btnView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.height.equalTo(486)
            $0.width.bottom.equalToSuperview()
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        blockCntView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(57)
        }
        
        recordView.snp.makeConstraints {
            $0.top.equalTo(blockCntView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(114)
        }
        
        friendBtn.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.height.equalTo(98)
        }
        
        myRecordBtn.snp.makeConstraints {
            $0.centerY.equalTo(friendBtn.snp.centerY)
            $0.leading.equalTo(friendBtn.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(98)
            $0.width.equalTo(friendBtn.snp.width)
        }
        
        settingBtnStackView.snp.makeConstraints {
            $0.top.equalTo(friendBtn.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-68)
        }
        
        [setLocationBtn, setPrivacyBtn, setAlarmBtn, termsBtn, inquiryBtn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(56)
            }
        }
    }
}

// MARK: - Input

extension MypageVC {
    private func bindBtn() {
        naviBar.rightBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let notificationBoxVC = NotificationBoxVC()
                notificationBoxVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(notificationBoxVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        myRecordBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let myRecordDataView = MyRecordDataVC()
                myRecordDataView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myRecordDataView, animated: true)
            })
            .disposed(by: disposeBag)
        
        friendBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let friendsVC = FriendsVC()
                friendsVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(friendsVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        setPrivacyBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let setPrivacyVC = SetPrivacyVC()
                setPrivacyVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(setPrivacyVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        setAlarmBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let setNotificationVC = SetNotificationVC()
                setNotificationVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(setNotificationVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        setLocationBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)
        
        termsBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let termsConditionsVC = TermsConditionsVC()
                termsConditionsVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(termsConditionsVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        inquiryBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if MFMailComposeViewController.canSendMail() {
                    let composeViewController = MFMailComposeViewController()
                    composeViewController.mailComposeDelegate = self
                    
                    let dictionary = Bundle.main.infoDictionary
                    let appVersion = dictionary?["CFBundleShortVersionString"]
                    
                    let bodyString = """
                                         안녕하세요 네모두 서비스와 관련하여 문의드립니다.
                                         
                                         <-- 문의내용 입력 -->
                                         
                                         -------------------
                                         Device OS Version : \(UIDevice.current.systemVersion)
                                         App Version : \(appVersion ?? "unknown")
                                         -------------------
                                    """
                    
                        composeViewController.setToRecipients(["nemodu.official@gmail.com"])
                        composeViewController.setSubject("네모두 서비스 관련문의")
                        composeViewController.setMessageBody(bodyString, isHTML: false)
                        
                        self.present(composeViewController, animated: true, completion: nil)
                    } else {
                        self.popUpAlert(alertType: .sendMailError, targetVC: self, highlightBtnAction: #selector(self.dismissAlert), normalBtnAction: nil)
                    }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindProfileTap() {
        profileView.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let myProfileVC = MyProfileVC()
                myProfileVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myProfileVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension MypageVC {
    private func bindUserData() {
        viewModel.output.userData
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.configureUserData(data)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Mail Delegate

extension MypageVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
