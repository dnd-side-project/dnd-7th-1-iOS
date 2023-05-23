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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            friendListTV.register(AddKakaoFriendTVC.self, forCellReuseIdentifier: AddKakaoFriendTVC.className)
        } else {
            // TODO: - TVC 변경
            friendListTV.register(AddKakaoFriendTVC.self, forCellReuseIdentifier: AddKakaoFriendTVC.className)
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
}
