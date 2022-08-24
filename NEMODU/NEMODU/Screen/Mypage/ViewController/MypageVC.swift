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
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .equalCentering
        }
    
    private let setLocationBtn = UIButton()
        .then {
            $0.setTitle("위치 정보 동의 설정", for: .normal)
        }
    
    private let setAlarmBtn = UIButton()
        .then {
            $0.setTitle("알림 설정", for: .normal)
        }
    
    private let termsBtn = UIButton()
        .then {
            $0.setTitle("이용 약관", for: .normal)
        }
    
    private let inquiryBtn = UIButton()
        .then {
            $0.setTitle("문의하기", for: .normal)
        }
    
    private let naviBar = NavigationBar()
    
    private let viewModel = MypageVM()
    private let bag = DisposeBag()
    
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
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindUserData()
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
        
        [setLocationBtn, setAlarmBtn, termsBtn, inquiryBtn].forEach {
            $0.titleLabel?.font = .body1
            $0.setTitleColor(.gray900, for: .normal)
            $0.contentHorizontalAlignment = .left
            
            let arrowImage = UIImageView(image: UIImage(named: "arrow_right")?
                .withTintColor(.gray300, renderingMode: .alwaysOriginal))
            $0.addSubview(arrowImage)
            arrowImage.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(24)
            }
            settingBtnStackView.addArrangedSubview($0)
        }
        settingBtnStackView.addHorizontalSeparators(color: .gray50, height: 1)
    }
    
    private func configureUserData(_ userData: MypageUserDataResponseModel) {
        // TODO: - 서버 프로필 이미지 추가 후 수정
//        profileView.profileImage.image =
        profileView.nickname.text = userData.nickname
        profileView.profileMessage.text = userData.intro
        blockCntView.configureBlockCnt(userData.allMatrixNumber)
        recordView.firstView.recordValue.text = "\(userData.matrixNumber) 칸"
        recordView.secondView.recordValue.text = "\(userData.stepCount)"
        recordView.thirdView.recordValue.text = "\(userData.distance) m"
        friendBtn.setTitle("친구 \(userData.friendNumber)명", for: .normal)
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
            $0.height.equalTo(430)
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
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-68)
        }
    }
}

// MARK: - Input

extension MypageVC {
    private func bindBtn() {
        myRecordBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let myRecordDataView = MyRecordDataVC()
                myRecordDataView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myRecordDataView, animated: true)
            })
            .disposed(by: bag)
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
            .disposed(by: bag)
    }
}
