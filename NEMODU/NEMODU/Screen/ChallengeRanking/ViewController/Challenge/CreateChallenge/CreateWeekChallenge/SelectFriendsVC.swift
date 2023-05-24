//
//  SelectFriendsVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/26.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SelectFriendsVC: CreateChallengeVC {
    
    // MARK: - UI components
    
    private let friendsListContainerView = UIView()
        .then {
            $0.isHidden = true
        }
    private lazy var friendsListView1 = FriendListView()
        .then {
            $0.cancelButton.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
            $0.cancelButton.tag = 0
            $0.isHidden = true
        }
    private lazy var friendsListView2 = FriendListView()
        .then {
            $0.cancelButton.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
            $0.cancelButton.tag = 1
            $0.isHidden = true
        }
    private lazy var friendsListView3 = FriendListView()
        .then {
            $0.cancelButton.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
            $0.cancelButton.tag = 2
            $0.isHidden = true
        }
    
    private let searchTextField = UITextField()
        .then {
            $0.font = .body2
            $0.textColor = .gray900
            $0.attributedPlaceholder = NSAttributedString(string: "닉네임으로 검색",
                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray500,
                                                                   NSAttributedString.Key.font: UIFont.body3])
            
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 0))
            $0.leftViewMode = .always
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 0))
            $0.rightViewMode = .always
            
            $0.backgroundColor = .gray50
            
            $0.tintColor = .main
            $0.returnKeyType = .search
            
            $0.layer.cornerRadius = 8
    }
    
    private let searchImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray500
        }
    private lazy var deleteAllTextButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray400
            
            $0.isHidden = true
        }
    
    private let guideLabel = PaddingLabel()
        .then {
            $0.text = "최대 3명까지 초대할 수 있습니다."
            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            $0.font = .body4
            $0.textColor = .gray400
            
            $0.backgroundColor = .white
        }
    private let limitFriendsCountLabel = PaddingLabel()
        .then {
            $0.text = "( 0 / 3 )"
            
            $0.font = .body4
            $0.textColor = .gray900
            
            $0.backgroundColor = .white
        }
    
    private let friendsListTableView = UITableView()
        .then {
            $0.separatorStyle = .none
            $0.allowsMultipleSelection = true
            $0.rowHeight = UITableView.automaticDimension
        }
    
    // MARK: - Variables and Properties
    
    var createWeekChallengeVC: CreateWeekChallengeVC?
    
    private let viewModel = SelectFriendsVM()
    private var friendsListResponseModel: [FriendDefaultInfo]?
    
    private var selectedFriendsList: [FriendDefaultInfo] = []
    
    private var friendsListContainerViewHeightConstraint: Constraint?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getFriendsList(size: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
        configureTableView()
        configureConfirmButon()
    }
    
    override func layoutView() {
        super.layoutView()
    
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindSearchTextField()
        bindButtons()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindAPIErrorAlert(viewModel)
        responseFriendsList()
    }
    
    // MARK: - Functions
    
    private func showSelectedFriend(friendInfo: FriendDefaultInfo) {
        selectedFriendsList.append(friendInfo)
        
        // 친구목록 컨테이너 창 크기 조절하기
        if selectedFriendsList.count == 1 {
            DispatchQueue.global().sync {
                friendsListContainerViewHeightConstraint?.layoutConstraints[0].constant = 123
                
                UIView.animate(withDuration: 0.3, delay: 0, animations: { [self] in
                    self.view.layoutIfNeeded()
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                    friendsListContainerView.isHidden = false
                    friendsListContainerView.alpha = 1
                }
            }
        }
        
        // 선택 친구목록 표시
        if friendsListView1.isHidden == true {
            configureFriendListView(friendListView: friendsListView1, friendInfo: friendInfo)
        } else if friendsListView2.isHidden == true {
            configureFriendListView(friendListView: friendsListView2, friendInfo: friendInfo)
        } else if friendsListView3.isHidden == true {
            configureFriendListView(friendListView: friendsListView3, friendInfo: friendInfo)
        }
    }
    
    private func deleteSelectedFriend(friendInfo: FriendDefaultInfo) {
        var seletedFriendsProfileList: [UIImage] = []
        [friendsListView1, friendsListView2, friendsListView3].forEach {
            seletedFriendsProfileList.append($0.profileImageView.image ?? .defaultThumbnail)
        }
        
        var targetIndex = 0
        for index in 0..<selectedFriendsList.count {
            if(selectedFriendsList[index].nickname == friendInfo.nickname) {
                targetIndex = index
                break
            }
        }
        
        selectedFriendsList.remove(at: targetIndex)
        seletedFriendsProfileList.remove(at: targetIndex)
        
        // 선택 친구목록 제거
        switch selectedFriendsList.count {
        case 2:
            friendsListView3.isHidden = true
            
            friendsListView2.nicknameLabel.text = selectedFriendsList[1].nickname
            friendsListView2.profileImageView.image = seletedFriendsProfileList[1]
            
            friendsListView1.nicknameLabel.text = selectedFriendsList[0].nickname
            friendsListView1.profileImageView.image = seletedFriendsProfileList[0]
        case 1:
            friendsListView2.isHidden = true
            
            friendsListView1.nicknameLabel.text = selectedFriendsList[0].nickname
            friendsListView1.profileImageView.image = seletedFriendsProfileList[0]
        case 0:
            friendsListView1.isHidden = true
            
            friendsListContainerViewHeightConstraint?.layoutConstraints[0].constant = 0
            friendsListContainerView.isHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, animations: { [self] in
                friendsListContainerView.alpha = 0
                self.view.layoutIfNeeded()
            })
        default:
            break
        }
    }
    
    @objc
    private func didTapCancelButton(_ sender: UIButton) {
        guard let friendsList = friendsListResponseModel else { return }
        
        var targetIndex = 3
        for i in 0..<friendsList.count {
            if friendsList[i].nickname == selectedFriendsList[sender.tag].nickname {
                targetIndex = i
                break
            }
        }
        
        if targetIndex != 3 {
            let deselectedIndexPath = IndexPath(row: targetIndex, section: 0)
            tableView(friendsListTableView, didDeselectRowAt: deselectedIndexPath)
            friendsListTableView.deselectRow(at: deselectedIndexPath, animated: true)
        }
    }
    
    private func updateLimitFriendsCountLabel() {
        limitFriendsCountLabel.text = "( \(selectedFriendsList.count) / 3 )"
    }
    
    private func checkConfirmButtonEnable() {
        selectedFriendsList.count > 0 ? (confirmButton.isSelected = true) : (confirmButton.isSelected = false)
    }
    
    override func didTapConfirmButton() {
        if selectedFriendsList.count > 0 {
            createWeekChallengeVC?.friends = selectedFriendsList
            
            dismiss(animated: true)
        }
    }
 
}

// MARK: - Configure

extension SelectFriendsVC {
    
    private func configureNavigationBar() {
        _ = navigationBar
            .then {
                $0.naviType = .present
                $0.configureNaviBar(targetVC: self, title: "친구 초대하기")
                $0.configureBackBtn(targetVC: self)
            }
    }
    
    private func configureFriendListView(friendListView: FriendListView, friendInfo: FriendDefaultInfo) {
        friendListView.isHidden = false
        friendListView.configureFriendsListView(friendInfo: friendInfo)
    }
    
    private func configureTableView() {
        _ = friendsListTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(SelectFriendsTVC.self, forCellReuseIdentifier: SelectFriendsTVC.className)
                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
            }
    }
    
    private func configureConfirmButon() {
        _ = confirmButton
            .then {
                $0.setTitle("완료", for: .normal)
                $0.isEnabled = true
            }
    }
    
}

// MARK: - Layout

extension SelectFriendsVC {
    
    private func configureLayout() {
        view.addSubviews([friendsListContainerView,
                          searchTextField,
                          guideLabel, limitFriendsCountLabel,
                          friendsListTableView])
        friendsListContainerView.addSubviews([friendsListView1, friendsListView2, friendsListView3])
        searchTextField.addSubviews([searchImageView, deleteAllTextButton])
        
        
        friendsListContainerView.snp.makeConstraints {
            friendsListContainerViewHeightConstraint = $0.height.equalTo(0).constraint

            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view).inset(16)
        }
        friendsListView1.snp.makeConstraints {
            $0.centerY.equalTo(friendsListContainerView)
            $0.left.equalTo(friendsListContainerView.snp.left)
        }
        friendsListView2.snp.makeConstraints {
            $0.centerY.equalTo(friendsListView1)
            $0.left.equalTo(friendsListView1.snp.right).offset(12)
        }
        friendsListView3.snp.makeConstraints {
            $0.centerY.equalTo(friendsListView2)
            $0.left.equalTo(friendsListView2.snp.right).offset(12)
        }

        searchTextField.snp.makeConstraints {
            $0.height.equalTo(42)
            
            $0.top.equalTo(friendsListContainerView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view).inset(16)
        }
        searchImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)

            $0.centerY.equalTo(searchTextField)
            $0.left.equalTo(searchTextField.snp.left).offset(12)
        }
        deleteAllTextButton.snp.makeConstraints {
            $0.width.height.equalTo(16)

            $0.centerY.equalTo(searchTextField)
            $0.right.equalTo(searchTextField.snp.right).inset(13)
        }
        
        guideLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view)
        }
        limitFriendsCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(guideLabel)
            $0.right.equalTo(view.snp.right).inset(16)
        }
        
        friendsListTableView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom)
            $0.horizontalEdges.equalTo(view)
            $0.bottom.equalTo(confirmButton.snp.top).inset(-24)
        }
    }
    
}

// MARK: - TableView DataSource

extension SelectFriendsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectFriendsTVC.className, for: indexPath) as? SelectFriendsTVC else {
            return UITableViewCell()
        }
        guard let friendsList = friendsListResponseModel else { return UITableViewCell() }
        cell.configureSelectFriendsTVC(friendInfo: friendsList[indexPath.row])
        
        return cell
    }

}

// MARK: - TableView Delegate

extension SelectFriendsVC : UITableViewDelegate {
    
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsListResponseModel?.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectFriendsTVC else { return }
        cell.didTapCheck()
        
        guard let friendsList = friendsListResponseModel else { return }
        showSelectedFriend(friendInfo: friendsList[indexPath.row])
        
        updateLimitFriendsCountLabel()
        checkConfirmButtonEnable()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectFriendsTVC else { return }
        cell.didTapCheck()
        
        guard let friendsList = friendsListResponseModel else { return }
        deleteSelectedFriend(friendInfo: friendsList[indexPath.row])

        updateLimitFriendsCountLabel()
        checkConfirmButtonEnable()
    }
    
    // 친구선택 수 제한
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableView.indexPathsForSelectedRows?.count ?? 0 < 3 ? indexPath : nil
    }
    
    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV else { return UITableViewHeaderFooterView() }
        footerView.statusLabel.text = "목록이 없습니다"

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let friendsList = friendsListResponseModel else { return 93 }
        return friendsList.count == 0 ? 93 : .leastNormalMagnitude
    }
   
}

// MARK: - Input

extension SelectFriendsVC {
    
    private func bindSearchTextField() {
        searchTextField.rx.text.changed
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self,
                let searchNickname = text else { return }
                
                searchNickname.count == 0 ? (self.deleteAllTextButton.isHidden = true) : (self.deleteAllTextButton.isHidden = false)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindButtons() {
        deleteAllTextButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.searchTextField.text = ""
                self.deleteAllTextButton.isHidden = true
                self.searchTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Output

extension SelectFriendsVC {
    
    private func responseFriendsList() {
        viewModel.output.friendsList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.friendsListResponseModel = data
                self.friendsListTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
}
