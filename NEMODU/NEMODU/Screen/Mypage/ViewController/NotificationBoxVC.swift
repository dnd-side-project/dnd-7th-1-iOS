//
//  NotificationBoxVC.swift
//  NEMODU
//
//  Created by Kime HeeJae on 2023/05/04.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class NotificationBoxVC: BaseViewController {
    
    // MARK: - UI components
    
    private let navigationBar = NavigationBar()
    
    private let statusEmptyStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 12.0
            $0.distribution = .fill
            $0.alignment = .center
        }
    private let statusEmptyImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray300
        }
    private let statusEmptyLabel = UILabel()
        .then {
            $0.text = "받은 알림이 없습니다."
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    private let notificationListTableView = UITableView()
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            
            $0.showsVerticalScrollIndicator = false
            
            $0.estimatedRowHeight = 82.0
            $0.rowHeight = UITableView.automaticDimension
        }
    
    // MARK: - Variables and Properties
    
    private let viewModel = NotificationBoxVM()
    var notificationBoxResponseModel: NotificationBoxResponseModel?
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserNotificationList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        markCommonNotificationRead()
    }
    
    override func configureView() {
        super.configureView()
    
        configureNavigationBar()
        configureNotificationListTableView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindTableView()
    }
    
    // MARK: - Functions
    
    private func getUserNotificationList() {
        viewModel.getUserNotificationList()
    }
    
    private func markUserNotificationRead(selectedNotificationMessageId: String) {
        viewModel.markUserNotificationRead(targetMessageId: selectedNotificationMessageId)
    }
    
    private func markCommonNotificationRead() {
        notificationBoxResponseModel?.forEach {
            // 클릭시 아무런 액션이 없는 알림인 경우
            if($0.type == NotificationListIcon.common.description) {
                // 알림목록 조회 이후 일괄 읽음처리
                markUserNotificationRead(selectedNotificationMessageId: $0.messageId)
            }
        }
    }
    
}

// MARK: - Configure

extension NotificationBoxVC {
    
    private func configureNavigationBar() {
        navigationBar.naviType = .push
        navigationBar.configureNaviBar(targetVC: self,
                                 title: "알림함")
        navigationBar.configureBackBtn(targetVC: self)
        navigationBar.configureRightBarBtn(targetVC: self, title: "비우기", titleColor: .main)
    }
    
    private func configureNotificationListTableView() {
        notificationListTableView.delegate = self
        notificationListTableView.dataSource = self
        
        notificationListTableView.register(NotificationListTVC.self, forCellReuseIdentifier: NotificationListTVC.className)
    }
    
}

// MARK: - Layout

extension NotificationBoxVC {
    
    private func configureLayout() {
        view.addSubviews([statusEmptyStackView,
                          notificationListTableView])
        [statusEmptyImageView, statusEmptyLabel].forEach {
            statusEmptyStackView.addArrangedSubview($0)
        }
        
        
        statusEmptyStackView.snp.makeConstraints {
            $0.width.equalTo(123.0)
            $0.center.equalTo(view)
        }
        statusEmptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(90.0)
        }
        
        notificationListTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
    }
    
}

// MARK: - Input

extension NotificationBoxVC {
    
    private func bindButton() {
        navigationBar.rightBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                var messageIdList = [String]()
                notificationBoxResponseModel?.forEach {
                    messageIdList.append($0.messageId)
                }
                viewModel.emptyNotificationList(messageIdList: messageIdList)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Output

extension NotificationBoxVC {
    
    private func bindTableView() {
        viewModel.output.notificationList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                notificationBoxResponseModel = data
                notificationListTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isEmptyNotificationList
            .subscribe(onNext: { [weak self] isEmpty in
                guard let self = self else { return }
                
                if isEmpty {
                    self.notificationListTableView.isHidden = true
                    
                    self.navigationBar.rightBtn.isEnabled = false
                    self.navigationBar.rightBtn.setTitleColor(.gray300, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - TableView DataSource

extension NotificationBoxVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationBoxResponseModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListTVC.className, for: indexPath) as? NotificationListTVC else { return UITableViewCell() }
        guard let notificationList = notificationBoxResponseModel else { return UITableViewCell() }
        cell.configureNotificationListTVC(notificationInfo: notificationList[indexPath.row])
        
        return cell
    }
    
}

// MARK: - TableView Delegate

extension NotificationBoxVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedNotification = notificationBoxResponseModel?[indexPath.row] else { return }
        
        var toPushVC = UIViewController()
        switch selectedNotification.type {
            // 친구 요청, 수락 시 마이페이지의 친구화면으로 전환
        case NotificationListIcon.friend.description:
            let friendsVC = FriendsVC()
            friendsVC.hidesBottomBarWhenPushed = true
            
            toPushVC = friendsVC
            
            // 초대, 수락, 시작 전 챌린지의 상세화면으로 전환
        case NotificationListIcon.challenge.description:
            // TODO: - 해당 알림의 챌린지 uuid값 필요
//            guard let targetUUID = userInfo["challenge_uuid"] as? String else { return }
            
            let invitedChallengeDetailVC = InvitedChallengeDetailVC()
            invitedChallengeDetailVC.hidesBottomBarWhenPushed = true
            
            // TODO: - 해당 챌린지 uuid로 푸시
//            invitedChallengeDetailVC.uuid = targetUUID
            invitedChallengeDetailVC.getInvitedChallengeDetailInfo()
            
            toPushVC = invitedChallengeDetailVC
            // TODO: - 해당 챌린지의 uuid값 조회 전까지 navigation push 제한
            return
            
        default:
            return
        }
        
        markUserNotificationRead(selectedNotificationMessageId: selectedNotification.messageId)
        navigationController?.pushViewController(toPushVC, animated: true)
    }
    
}
