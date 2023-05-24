//
//  AddFriendsVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/12.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import RxDataSources

class AddFriendsVC: BaseViewController {
    private let titleLabel = UILabel()
        .then {
            $0.font = .title1
            $0.textColor = .gray900
            $0.setLineBreakMode()
        }
    
    private let messageLabel = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray700
            $0.setLineBreakMode()
        }
    
    private let subTitleLabel = UILabel()
        .then {
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let friendListTV = UITableView(frame: .zero)
        .then {
            $0.separatorStyle = .none
            $0.rowHeight = 64
        }
    
    private let viewModel = RecommendListVM()
    private let listType = UserDefaults.standard.string(forKey: UserDefaults.Keys.loginType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let listType = listType else { return }
        listType == LoginType.kakao.rawValue
        ? viewModel.getKakaoFriendList(size: 15)
        : viewModel.getNEMODUFriendList(size: 15)
    }
    
    override func configureView() {
        super.configureView()
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
        bindAPIErrorAlert(viewModel)
        
        guard let listType = listType else { return }
        listType == LoginType.kakao.rawValue
        ? bindKakaoRecommendTV()
        : bindNemoduRecommendTV()
    }
    
}

// MARK: - Configure

extension AddFriendsVC {
    private func configureContentView() {
        view.addSubviews([titleLabel,
                          messageLabel,
                          subTitleLabel,
                          friendListTV])
        
        
        if listType == LoginType.kakao.rawValue {
            titleLabel.text = "카카오톡 친구"
            messageLabel.text = "친구가 되면 함께 챌린지를 할 수 있어요.\n친구 요청을 보내보세요!"
            subTitleLabel.text = "카카오톡 친구"
            
            friendListTV.register(AddKakaoFriendTVC.self, forCellReuseIdentifier: AddKakaoFriendTVC.className)
            
        } else {
            titleLabel.text = "함께 할 수 있는\n네모두 친구"
            messageLabel.text = "활동하고 있는 네모두 친구들이에요!\n함께 해보는거 어떨까요?"
            subTitleLabel.text = "네모두 친구"
            
            friendListTV.register(AddNemoduFriendTVC.self, forCellReuseIdentifier: AddNemoduFriendTVC.className)
        }
    }
}

// MARK: - Layout

extension AddFriendsVC {
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        friendListTV.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension AddFriendsVC {
    
}

// MARK: - Output

extension AddFriendsVC {
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

extension AddFriendsVC {
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
                cell.configureCell(item)
                return cell
            }
        )
    }
}
