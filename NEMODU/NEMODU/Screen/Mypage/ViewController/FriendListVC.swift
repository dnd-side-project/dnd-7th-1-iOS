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
    
    private let friendNoneMessageLabel = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.text = "아직 친구가 없습니다.\n추천 친구에서 추가해보세요!"
            $0.textAlignment = .center
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    private let friendListTV = UITableView()
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.rowHeight = FriendListVC.friendCellHeight
        }
    
    // 삭제 요청된 친구 배열
    typealias DeletedFriend = (nickname: String, indexPath: IndexPath)
    var removedFriendsList = [DeletedFriend]()
    
    /// 친구 목록 편집 상태
    private var isFriendListEditing = false
    
    static let friendCellHeight = 64.0
    private let viewModel = FriendListVM()
    
    weak var delegate: NavigationBarBackBtnDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFriendRequestList(size: 6)
        viewModel.getFriendList(size: 12)
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
        bindEditFriendListBtn()
        bindFriendProfile()
        bindSearchBar()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindAPIErrorAlert(viewModel)
        bindFriendRequestTableView()
        bindFriendListTableView()
        bindFriendRequestHandlingStatus()
        bindToastView()
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
                                    friendNoneMessageLabel,
                                    friendListTV])
        
        requestHandlingTV.register(FriendRequestHandlingTVC.self,
                                   forCellReuseIdentifier: FriendRequestHandlingTVC.className)
        
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
        
        friendNoneMessageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(36)
        }
        
        friendListTV.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension FriendListVC {
    /// 친구 목록 편집 버튼 tap binding
    private func bindEditFriendListBtn() {
        editFriendListBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.editFriendListBtn.isSelected.toggle()
                self.isFriendListEditing = self.editFriendListBtn.isSelected
                self.delegate?.changeFriendListEditingStatus(self.isFriendListEditing)
                self.friendListTV.reloadData()
                if !self.editFriendListBtn.isSelected && !self.removedFriendsList.isEmpty {
                    self.viewModel.postDeleteFriendRequest(self.removedFriendsList.map { $0.nickname })
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFriendProfile() {
        friendListTV.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self,
                      let cell = self.friendListTV.cellForRow(at: indexPath) as? FriendListDefaultTVC,
                      let friend = cell.getNickname()
                else { return }
                self.friendListTV.deselectRow(at: indexPath, animated: true)
                let friendBottomSheet = FriendProfileBottomSheet()
                friendBottomSheet.nickname = friend
                friendBottomSheet.delegate = self
                self.present(friendBottomSheet, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let keyword = owner.searchBar.text ?? ""
                if keyword.count > 1 {
                    owner.viewModel.getSearchResult(keyword)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension FriendListVC {
    /// 친구 요청 목록 tableView 바인딩
    private func bindFriendRequestTableView() {
        viewModel.output.friendRequestList.dataSource
            .bind(to: requestHandlingTV.rx.items(dataSource: friendRequestTableViewDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.output.friendRequestList.friendsInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.requestNoneMessageLabel.isHidden = item.count != 0
                owner.requestHandlingTV.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    /// 내 친구 목록 tableView 바인딩
    private func bindFriendListTableView() {
        viewModel.output.myFriendsList.dataSource
            .bind(to: friendListTV.rx.items(dataSource: friendListTableViewDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.output.myFriendsList.friendsInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.friendNoneMessageLabel.isHidden = item.count != 0
                owner.friendListTV.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    /// 친구 요청을 수락/거절했을때 이벤트를 처리하는 메서드
    private func bindFriendRequestHandlingStatus() {
        viewModel.output.requestHandlingStatus
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                if data.status == FriendStatusType.accept.rawValue {
                    self.popupToast(toastType: .acceptFriendRequest(nickname: data.friendNickname))
                    self.viewModel.getFriendList(size: 12)
                } else {
                    self.popupToast(toastType: .refuseFriendRequest(nickname: data.friendNickname))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToastView() {
        viewModel.output.isDeleteCompleted
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                if status {
                    self.popupToast(toastType: .saveCompleted)
                    self.removedFriendsList.removeAll()
                }
                // 서버에서 status가 false인 경우인 존재하지 않음
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension FriendListVC {
    /// 친구 요청 목록 tableView DataSource
    func friendRequestTableViewDataSource() -> RxTableViewSectionedReloadDataSource<FriendListDataSource<FriendDefaultInfo>> {
        RxTableViewSectionedReloadDataSource<FriendListDataSource<FriendDefaultInfo>>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self = self,
                      let cell = tableView.dequeueReusableCell(
                    withIdentifier: FriendRequestHandlingTVC.className,
                    for: indexPath
                ) as? FriendRequestHandlingTVC else {
                    self?.dataSourceError(tableView)
                    return UITableViewCell()
                }
                cell.configureCell(item,
                                   indexPath: indexPath,
                                   delegate: self)
                return cell
            })
    }
    
    
    /// 내 친구 목록 tableView DataSource
    func friendListTableViewDataSource() -> RxTableViewSectionedReloadDataSource<FriendListDataSource<FriendDefaultInfo>> {
        RxTableViewSectionedReloadDataSource<FriendListDataSource<FriendDefaultInfo>>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self = self,
                      let cell = tableView.dequeueReusableCell(
                    withIdentifier: FriendListDefaultTVC.className,
                    for: indexPath
                ) as? FriendListDefaultTVC else {
                    self?.dataSourceError(tableView)
                    return UITableViewCell()
                }
                
                cell.configureCell(item,
                                   isEditing: self.isFriendListEditing,
                                   deleteDelegate: self,
                                   indexPath: indexPath)
                return cell
            })
    }
    
    /// tableView dataSource error 처리. Empty 화면 출력
    private func dataSourceError(_ tableView: UITableView) {
        popupToast(toastType: .informationError)
        tableView.isHidden = true
        if tableView == requestHandlingTV { requestNoneMessageLabel.isHidden = false }
        else if tableView == friendListTV { friendNoneMessageLabel.isHidden = false }
    }
}

// MARK: - DeleteFriendDelegate

extension FriendListVC: DeleteFriendDelegate {
    func popupDeleteAlert(nickname: String, indexPath: IndexPath) {
        // 편집 완료 버튼에서 모든 삭제가 진행되기 위해
        // 삭제 요청이 들어오면 일단 삭제 목록에 추가
        // 편집 상태 true로 변경 (뒤로가기 버튼 알람 연결)
        removedFriendsList += [(nickname, indexPath)]
        
        popUpAlert(alertType: .deleteFriend(nickname: nickname),
                   targetVC: self,
                   highlightBtnAction: #selector(deleteConfirm),
                   normalBtnAction: #selector(cancelDelete))
    }
    
    /// 삭제 확인 알람창 삭제 버튼 메서드.
    /// 친구 목록의 해당 row를 삭제하고 알람창 닫기
    @objc func deleteConfirm() {
        if !removedFriendsList.isEmpty {
            var items = viewModel.output.myFriendsList.friendsInfo.value
            items.remove(at: removedFriendsList.last!.indexPath.row)
            viewModel.output.myFriendsList.friendsInfo.accept(items)
        }
        
        dismissAlert()
    }
    
    /// 삭제 확인 알람창 취소 버튼 메서드.
    /// 삭제된 친구 목록의 마지막 친구를 삭제 (삭제 취소)
    @objc func cancelDelete() {
        removedFriendsList.removeLast()
        dismissAlert()
    }
}

// MARK: - FriendRequestHandlingDelegate

extension FriendListVC: FriendRequestHandlingDelegate {
    func acceptFriendRequest(nickname: String, indexPath: IndexPath) {
        removeRequestHandlingTVRow(indexPath)
        viewModel.postRequestHandling(FriendRequestHandlingModel(friendNickname: nickname,
                                                                 status: FriendStatusType.accept.rawValue))
    }
    
    func refuseFriendRequest(nickname: String, indexPath: IndexPath) {
        removeRequestHandlingTVRow(indexPath)
        viewModel.postRequestHandling(FriendRequestHandlingModel(friendNickname: nickname,
                                                                 status: FriendStatusType.reject.rawValue))
    }
    
    /// 친구 요청 거절/수락 후 requestHandlingTV에서 해당 row를 제거하는 메서드
    func removeRequestHandlingTVRow(_ indexPath: IndexPath) {
        var items = viewModel.output.friendRequestList.friendsInfo.value
        items.remove(at: indexPath.row)
        viewModel.output.friendRequestList.friendsInfo.accept(items)
    }
}

// MARK: - FriendProfileProtocol

extension FriendListVC: FriendProfileProtocol {
    func deselectAnnotation() {}
    
    func pushChallengeDetail(_ uuid: String) {
        let challengeDetailVC = ChallengeHistoryDetailVC()
        challengeDetailVC.getChallengeHistoryDetailInfo(uuid: uuid)
        challengeDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(challengeDetailVC, animated: true)
    }
}

// MARK: - NavigationBarBackBtnDelegate

protocol NavigationBarBackBtnDelegate: AnyObject {
    func changeFriendListEditingStatus(_ status: Bool)
}

