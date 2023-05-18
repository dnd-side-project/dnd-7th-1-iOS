//
//  FriendsVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class FriendsVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let menuBar = TabView()
        .then {
            $0.menu = ["친구 목록", "추천 친구"]
        }
    
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
        }
    
    private let baseStackView = UIStackView()
        .then {
            $0.spacing = 0
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .fill
        }
    
    private let friendListVC = FriendListVC()
    
    private let recommendListVC = RecommendListVC()
    
    private let bag = DisposeBag()
    
    /// 친구 목록 편집 상태
    private var isFriendListEditing = BehaviorRelay<Bool>(value: false)
    
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
        bindTabScroll()
        bindBackBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension FriendsVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: "친구")
        naviBar.configureBackBtn(targetVC: self)
    }
    
    private func configureContentView() {
        view.addSubviews([menuBar,
                          baseScrollView])
        baseScrollView.addSubview(baseStackView)
        [friendListVC, recommendListVC].forEach {
            addChild($0)
        }
        [friendListVC.view, recommendListVC.view].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        friendListVC.delegate = self
    }
}

// MARK: - Layout

extension FriendsVC {
    private func configureLayout() {
        menuBar.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(menuBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        baseStackView.snp.makeConstraints {
            $0.edges.height.centerY.equalToSuperview()
            $0.width.equalTo(screenWidth * 2)
        }
        
        friendListVC.view.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(screenWidth)
        }
        
        recommendListVC.view.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(screenWidth)
        }
    }
}

// MARK: - Input

extension FriendsVC {
    private func bindTabScroll() {
        menuBar.tabCV.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let offset = CGFloat(indexPath.row) * self.screenWidth
                self.baseScrollView.scrollToHorizontalOffset(offset: offset)
            })
            .disposed(by: bag)
        
        baseScrollView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] offset in
                guard let self = self else { return }
                let page = round(offset.x / self.screenWidth)
                if page.isNaN || page.isInfinite { return }
                self.menuBar.selectTab(Int(page))
            })
            .disposed(by: bag)
    }
    
    private func bindBackBtn() {
        // 기존 뒤로가기 pop 액션 remove
        naviBar.backBtn.removeTarget(self,
                                     action: #selector(self.popVC),
                                     for: .touchUpInside)
        // 편집 상태에 따라 binding
        naviBar.backBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isFriendListEditing.value
                ? self.popUpAlert(alertType: .discardChanges,
                                  targetVC: self,
                                  highlightBtnAction: #selector(self.dismissAlertAndPopVC),
                                  normalBtnAction: #selector(self.dismissAlert))
                : self.popVC()
            })
            .disposed(by: bag)
    }
}

// MARK: - NavigationBarBackBtnDelegate
extension FriendsVC: NavigationBarBackBtnDelegate {
    /// 편집 상태 변경
    func changeFriendListEditingStatus(_ status: Bool) {
        isFriendListEditing.accept(status)
    }
}
