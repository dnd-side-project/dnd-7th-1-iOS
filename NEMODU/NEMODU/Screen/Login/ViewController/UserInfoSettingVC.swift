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
            $0.isUserInteractionEnabled = false
            $0.showsHorizontalScrollIndicator = false
        }
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private var page: Float = 1
    private let pageCnt: Float = 2
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
        bindNaviBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
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
    
    private func configureContentView() {
        view.addSubviews([progressView,
                          baseScrollView])
        baseScrollView.addSubview(baseStackView)
        
        progressView.progress = page / pageCnt
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Input

extension UserInfoSettingVC {
    private func bindNaviBtn() {
        naviBar.backBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.page -= 1
                self.page != 0
                ? self.setPage(self.page)
                : self.popVC()
            })
            .disposed(by: bag)
        
        naviBar.rightBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.page += 1
                self.page != self.pageCnt + 1
                ? self.setPage(self.page)
                : self.setTBCtoRootVC()
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension UserInfoSettingVC {
    
}

// MARK: - Custom Methods

extension UserInfoSettingVC {
    private func setPage(_ page: Float) {
        baseScrollView.setContentOffset(CGPoint(x: screenWidth * CGFloat(page), y: 0), animated: true)
        progressView.progress = page / pageCnt
    }
}
