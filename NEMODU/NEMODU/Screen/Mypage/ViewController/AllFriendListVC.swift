//
//  AllFriendListVC.swift
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
import RxDataSources

class AllFriendListVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let searchBar = NicknameSearchBar()
    
    private let friendListTV = UITableView(frame: .zero)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.rowHeight = RecommendListVC.friendCellHeight
        }
    
    var listType: LoginType?
    
    private let viewModel = RecommendListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listType == .kakao
        ? viewModel.getKakaoFriendList(size: 15)
        : viewModel.getNEMODUFriendList(size: 15)
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
    }
    
    override func bindOutput() {
        super.bindOutput()
        listType == .kakao
        ? bindKakaoRecommendTV()
        : bindNemoduRecommendTV()
    }
}

// MARK: - Configure

extension AllFriendListVC {
    private func configureNaviBar() {
        guard let listType = listType else {
            popVC()
            return
        }
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: listType == .apple ? "네모두 추천 친구" : "카카오톡 추천 친구")
        naviBar.configureBackBtn(targetVC: self)
    }
    
    private func configureContentView() {
        view.addSubviews([searchBar,
                          friendListTV])
        
        if listType == .kakao {
            friendListTV.register(AddKakaoFriendTVC.self,
                                  forCellReuseIdentifier: AddKakaoFriendTVC.className)
        } else {
            friendListTV.register(AddNemoduFriendTVC.self,
                                  forCellReuseIdentifier: AddNemoduFriendTVC.className)
        }
    }
}

// MARK: - Layout

extension AllFriendListVC {
    private func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(42)
        }
        
        friendListTV.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension AllFriendListVC {
    
}

// MARK: - Output

extension AllFriendListVC {
    /// 카카오톡 추천 친구 목록 tableView 연결
    private func bindKakaoRecommendTV() {
        viewModel.output.kakaoFriendsList.dataSource
            .bind(to: friendListTV.rx.items(dataSource: kakaoTableViewDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.output.kakaoFriendsList.friendsInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.friendListTV.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    /// NEMODU 추천 친구 목록 tableView 연결
    private func bindNemoduRecommendTV() {
        viewModel.output.nemoduFriendslist.dataSource
            .bind(to: friendListTV.rx.items(dataSource: nemoduTableViewDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.output.nemoduFriendslist.friendsInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.friendListTV.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension AllFriendListVC {
    /// 카카오 추천 친구 목록 tableView DataSource
    func kakaoTableViewDataSource() -> RxTableViewSectionedReloadDataSource<FriendListDataSource<KakaoFriendInfo>> {
        RxTableViewSectionedReloadDataSource<FriendListDataSource<KakaoFriendInfo>>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: AddKakaoFriendTVC.className,
                        for: indexPath
                      ) as? AddKakaoFriendTVC
                else { return UITableViewCell() }
                cell.configureCell(item)
                return cell
            })
    }
    
    /// 네모두 추천 친구 목록 tableView DataSource
    func nemoduTableViewDataSource() -> RxTableViewSectionedReloadDataSource<FriendListDataSource<FriendDefaultInfo>> {
        RxTableViewSectionedReloadDataSource<FriendListDataSource<FriendDefaultInfo>> (
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: AddNemoduFriendTVC.className,
                    for: indexPath
                ) as? AddNemoduFriendTVC
                else { return UITableViewCell() }
                cell.delegate = self
                cell.configureCell(item)
                return cell
            }
        )
    }
}

// MARK: - PopupToastViewDelegate

extension AllFriendListVC: PopupToastViewDelegate {
    func popupToastView(_ toastType: ToastType) {
        popupToast(toastType: toastType)
    }
}
