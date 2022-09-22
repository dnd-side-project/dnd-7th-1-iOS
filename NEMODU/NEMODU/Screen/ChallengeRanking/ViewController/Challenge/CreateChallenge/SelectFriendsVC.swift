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
    
    let friendsListContainerView = UIView()
        .then {
            $0.isHidden = true
        }
    lazy var friendsListView1 = FriendListView()
        .then {
            $0.cancelButton.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
            $0.cancelButton.tag = 0
            $0.isHidden = true
        }
    lazy var friendsListView2 = FriendListView()
        .then {
            $0.cancelButton.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
            $0.cancelButton.tag = 1
            $0.isHidden = true
        }
    lazy var friendsListView3 = FriendListView()
        .then {
            $0.cancelButton.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
            $0.cancelButton.tag = 2
            $0.isHidden = true
        }
    
    let searchTextField = UITextField()
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
    
    let searchImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray500
        }
    lazy var deleteAllTextButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray400
            
            $0.isHidden = true
            
            $0.addTarget(self, action: #selector(didTapDeleteAllTextButton), for: .touchUpInside)
        }
    
    let guideLabel = PaddingLabel()
        .then {
            $0.text = "최대 3명까지 초대할 수 있습니다."
            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            $0.font = .body4
            $0.textColor = .gray400
            
            $0.backgroundColor = .white
        }
    let limitFriendsCountLabel = PaddingLabel()
        .then {
            $0.text = "( 0 / 3 )"
            
            $0.font = .body4
            $0.textColor = .gray900
            
            $0.backgroundColor = .white
        }
    
    let friendsListTableView = UITableView()
        .then {
            $0.separatorStyle = .none
            $0.allowsMultipleSelection = true
        }
    
    // MARK: - Variables and Properties
    
    var createWeekChallengeVC: CreateWeekChallengeVC?
    
    private let bag = DisposeBag()
    
    let friendsList = ["아무개 1", "아무개 2", "아무개 3", "아무개 4", "아무개 5"]
    var selectedFriendsList: [String] = []
    
    var friendsListContainerViewHeightConstraint: Constraint?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        _ = navigationBar
            .then {
                $0.naviType = .present
                $0.configureNaviBar(targetVC: self, title: "친구 초대하기")
                $0.configureBackBtn(targetVC: self)
            }
        
        _ = confirmButton
            .then {
                $0.setTitle("완료", for: .normal)
                $0.isEnabled = true
            }
        
        _ = friendsListTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(SelectFriendsTVC.self, forCellReuseIdentifier: SelectFriendsTVC.className)
            }
        
    }
    
    override func layoutView() {
        super.layoutView()
    
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
            $0.verticalEdges.equalTo(friendsListContainerView).inset(16)
            $0.left.equalTo(friendsListContainerView.snp.left)
        }
        friendsListView2.snp.makeConstraints {
            $0.verticalEdges.equalTo(friendsListView1)
            $0.left.equalTo(friendsListView1.snp.right).offset(12)
        }
        friendsListView3.snp.makeConstraints {
            $0.verticalEdges.equalTo(friendsListView1)
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
    
    override func bindInput() {
        super.bindInput()
        
        bindSearchTextField()
    }
    
    @objc
    func didTapDeleteAllTextButton() {
        searchTextField.text = ""
        bindSearchTextField()
    }
    
    @objc
    func didTapCancelButton(_ sender: UIButton) {
        guard let targetIndex = friendsList.firstIndex(of: selectedFriendsList[sender.tag]) else { return }
        let deselectedIndexPath = IndexPath(row: targetIndex, section: 0)
        
        tableView(friendsListTableView, didDeselectRowAt: deselectedIndexPath)
        friendsListTableView.deselectRow(at: deselectedIndexPath, animated: true)
    }
    
    func updateLimitFriendsCountLabel() {
        limitFriendsCountLabel.text = "( \(selectedFriendsList.count) / 3 )"
    }
    
    func checkConfirmButtonEnable() {
        selectedFriendsList.count > 0 ? (confirmButton.isSelected = true) : (confirmButton.isSelected = false)
    }
    
    override func didTapConfirmButton() {
        if selectedFriendsList.count > 0 {
            createWeekChallengeVC?.friends = selectedFriendsList
            
            dismiss(animated: true)
        }
    }
 
}

// MARK: - SelectFriends TableView Delegate

extension SelectFriendsVC : UITableViewDelegate { }

// MARK: - SelectFriends TableView DataSource

extension SelectFriendsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectFriendsTVC.className, for: indexPath) as? SelectFriendsTVC else {
            return UITableViewCell()
        }
        cell.userNicknameLabel.text = friendsList[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectFriendsTVC
        cell.didTapCheck()
        
        selectedFriendsList.append(friendsList[indexPath.row])

        updateLimitFriendsCountLabel()
        checkConfirmButtonEnable()
        
        // 친구목록 컨테이너 표시하기
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
        
        // 친구 선택목록 표시
        if friendsListView1.isHidden == true {
            friendsListView1.isHidden = false
            friendsListView1.nicknameLabel.text = friendsList[indexPath.row]
        } else if friendsListView2.isHidden == true {
            friendsListView2.isHidden = false
            friendsListView2.nicknameLabel.text = friendsList[indexPath.row]
        } else if friendsListView3.isHidden == true {
            friendsListView3.isHidden = false
            friendsListView3.nicknameLabel.text = friendsList[indexPath.row]
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectFriendsTVC
        cell.didTapCheck()
        
        // 친구 선택목록 표시
        guard let targetIndex = selectedFriendsList.firstIndex(of: friendsList[indexPath.row]) else { return }
        selectedFriendsList.remove(at: targetIndex)
        
        switch selectedFriendsList.count {
        case 2:
            friendsListView3.isHidden = true
            friendsListView2.nicknameLabel.text = selectedFriendsList[1]
            friendsListView1.nicknameLabel.text = selectedFriendsList[0]
        case 1:
            friendsListView2.isHidden = true
            friendsListView1.nicknameLabel.text = selectedFriendsList[0]
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
        
        checkConfirmButtonEnable()
        updateLimitFriendsCountLabel()
    }
    
    // 친구선택 수 제한
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableView.indexPathsForSelectedRows?.count ?? 0 < 3 ? indexPath : nil
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
            .disposed(by: bag)
    }
    
}
