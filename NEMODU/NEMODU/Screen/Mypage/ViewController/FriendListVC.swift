//
//  FriendListVC.swift
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
import RxDataSources

class FriendListVC: BaseViewController {
    private let requestView = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }
    
    private let requestTitleLabel = UILabel()
        .then {
            $0.text = "친구 요청"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let requestNoneMessageLabel = UILabel()
        .then {
            $0.text = "받은 친구 요청이 없습니다."
            $0.textAlignment = .center
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    private let requestHandlingTV = ContentSizedTableView(frame: .zero)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.rowHeight = 64
        }
    
    private let friendListView = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }
    
    private let friendListTitleLabel = UILabel()
        .then {
            $0.text = "친구 목록"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let editFriendListBtn = UIButton()
        .then {
            $0.titleLabel?.font = .body3
            $0.semanticContentAttribute = .forceRightToLeft
            $0.setTitle("편집", for: .normal)
            $0.setTitle("편집 완료", for: .selected)
            $0.setTitleColor(.gray500, for: .normal)
            $0.setTitleColor(.main, for: .selected)
            $0.setImage(UIImage(named: "edit_Friends"),
                        for: .normal)
            $0.setImage(UIImage(named: "edit_Friends")?
                .withTintColor(.main),
                        for: .selected)
        }
    
    private let searchBar = NicknameSearchBar()
    
    private let separatorView = UIView()
        .then {
            $0.backgroundColor = .gray200
        }
    
    private let friendListTV = UITableView()
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.rowHeight = FriendListVC.friendCellHeight
        }
    
    static let friendCellHeight = 64.0
    private var isFriendListEditing = false
    private let viewModel = FriendListVM()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindFriendListTableView()
    }
}

// MARK: - Configure

extension FriendListVC {
    private func configureContentView() {
        view.backgroundColor = .gray50
        view.addSubviews([requestView,
                          friendListView])
        requestView.addSubviews([requestTitleLabel,
                                 requestNoneMessageLabel,
                                 requestHandlingTV])
        friendListView.addSubviews([friendListTitleLabel,
                                    editFriendListBtn,
                                    separatorView,
                                    searchBar,
                                    friendListTV])
        
        requestHandlingTV.register(FriendRequestHandlingTVC.self,
                                   forCellReuseIdentifier: FriendRequestHandlingTVC.className)
        requestHandlingTV.dataSource = self
        
        friendListTV.register(FriendListDefaultTVC.self,
                              forCellReuseIdentifier: FriendListDefaultTVC.className)
    }
}

// MARK: - Layout

extension FriendListVC {
    private func configureLayout() {
        requestView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        requestTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        requestNoneMessageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(requestTitleLabel.snp.bottom).offset(28)
        }
        
        requestHandlingTV.snp.makeConstraints {
            $0.top.equalTo(requestTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(64).priority(.high)
            $0.height.lessThanOrEqualTo(FriendListVC.friendCellHeight * 3).priority(.high)
        }
        
        friendListView.snp.makeConstraints {
            $0.top.equalTo(requestView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        friendListTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        editFriendListBtn.snp.makeConstraints {
            $0.centerY.equalTo(friendListTitleLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(friendListTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(8)
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

extension FriendListVC {
    private func bindBtn() {
        editFriendListBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.editFriendListBtn.isSelected.toggle()
                self.isFriendListEditing = self.editFriendListBtn.isSelected
                self.friendListTV.reloadData()
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension FriendListVC {
    /// 내 친구 목록 tableView 바인딩
    private func bindFriendListTableView() {
        viewModel.output.myFriendsList.dataSource
            .bind(to: friendListTV.rx.items(dataSource: friendListTableViewDataSource()))
            .disposed(by: bag)
        
        viewModel.output.myFriendsList.friendsInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.friendListTV.reloadData()
            })
            .disposed(by: bag)
    }
}

// MARK: - DataSource

extension FriendListVC {
    /// 내 친구 목록 tableView DataSource
    func friendListTableViewDataSource() -> RxTableViewSectionedReloadDataSource<FriendListDataSource> {
        RxTableViewSectionedReloadDataSource<FriendListDataSource>(
            configureCell: {[weak self] dataSource, tableView, indexPath, item in
                guard let self = self,
                      let cell = tableView.dequeueReusableCell(
                    withIdentifier: FriendListDefaultTVC.className,
                    for: indexPath
                ) as? FriendListDefaultTVC else {
                    fatalError()
                }
                cell.configureCell(item, isEditing: self.isFriendListEditing)
                return cell
            })
    }
}

// MARK: - UITableViewDataSource

extension FriendListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let requestHandlingCell = requestHandlingTV.dequeueReusableCell(withIdentifier: FriendRequestHandlingTVC.className) as? FriendRequestHandlingTVC else { return UITableViewCell() }
//            requestHandlingCell.configureCell(<#T##friendInfo: FriendsInfo##FriendsInfo#>)
        return requestHandlingCell
    }
}
