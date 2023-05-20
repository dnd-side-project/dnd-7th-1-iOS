//
//  UserInfoSettingVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/08.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class UserInfoSettingVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let progressView = UIProgressView()
        .then {
            $0.progressTintColor = .main
            $0.trackTintColor = .main40
        }
    
    private let baseScrollView = UIScrollView()
        .then {
            $0.isScrollEnabled = false
            $0.showsHorizontalScrollIndicator = false
        }
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private let nicknameVC = NicknameVC()
    private let addfriendsVC = AddFriendsVC()
    private let locationSettingVC = LocationSettingVC()
    
    private var page: Float = 1
    private let pageCnt: Float = 3
    
    private let viewModel = UserInfoSettingVM()
    
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
        bindNaviBtn()
    }
    
}

// MARK: - Configure

extension UserInfoSettingVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: nil)
        naviBar.configureRightBarBtn(targetVC: self,
                                     title: "다음",
                                     titleColor: .gray300)
        naviBar.configureBackBtn(targetVC: self)
        naviBar.backBtn.removeTarget(nil,
                                     action: nil,
                                     for: .allEvents)
    }
    
    private func setRightBarBtnActive(_ isActive: Bool) {
        naviBar.rightBtn.isUserInteractionEnabled = isActive
        naviBar.rightBtn.setTitleColor(isActive ? .main : .gray300, for: .normal)
    }
    
    private func configureContentView() {
        view.addSubviews([progressView,
                          baseScrollView])
        addChild(nicknameVC)
        addChild(addfriendsVC)
        addChild(locationSettingVC)
        
        baseScrollView.addSubview(baseStackView)
        [nicknameVC.view, addfriendsVC.view, locationSettingVC.view].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        nicknameVC.delegate = self
        
        progressView.progress = page / pageCnt
        
        setRightBarBtnActive(viewModel.output.isNextBtnActive.value)
    }
}

// MARK: - Layout

extension UserInfoSettingVC {
    private func configureLayout() {
        progressView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        baseStackView.snp.makeConstraints {
            $0.edges.centerY.equalToSuperview()
            $0.width.equalTo(screenWidth * CGFloat(pageCnt))
        }
    }
}

// MARK: - Input

extension UserInfoSettingVC {
    private func bindNaviBtn() {
        naviBar.backBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      self.page > 1 else { return }
                if self.page == 3 { self.naviBar.rightBtn.setTitle("다음", for: .normal) }
                self.page -= 1
                self.page != 0
                ? self.setPage(self.page)
                : self.popVC()
            })
            .disposed(by: disposeBag)
        
        naviBar.rightBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      self.page <= 3 else { return }
                self.page += 1
                
                if self.page != self.pageCnt + 1 {
                    self.setPage(self.page)
                } else {
                    let enterVC = EnterVC()
                    // TODO: - 친구 목록 연결
                    enterVC.userDataModel = UserDataModel(friends: [],
                                                          isPublicRecord: self.locationSettingVC.getSignupValue())
                    self.navigationController?.pushViewController(enterVC, animated: true)
                }
                
                if self.page == 3 { self.naviBar.rightBtn.setTitle("완료", for: .normal) }
            })
            .disposed(by: disposeBag)
        
        baseScrollView.rx.didScroll
            .asDriver()
            .drive(onNext: {[weak self] offset in
                guard let self = self else { return }
                let progress = (self.baseScrollView.contentOffset.x + self.screenWidth) / self.screenWidth
                self.progressView.progress = Float(progress) / self.pageCnt
            })
            .disposed(by: disposeBag)
    }
}
// MARK: - Custom Methods

extension UserInfoSettingVC {
    private func setPage(_ page: Float) {
        baseScrollView.scrollToHorizontalOffset(offset: screenWidth * CGFloat(page - 1))
    }
}

// MARK: - NavigationBarNextBtnDelegate

extension UserInfoSettingVC: NavigationBarNextBtnDelegate {
    func changeNaviBarNextBtnActiveStatus(_ status: Bool) {
        setRightBarBtnActive(status)
    }
}
