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
    
    private func bindTableView() {
        viewModel.output.notificationList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                notificationBoxResponseModel = data
                notificationListTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindButton() {
        navigationBar.rightBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("알림 전체 비우기 클릭") // TODO: 알림 전체 비우는 서버호출
                
                self.notificationListTableView.reloadData()
                self.notificationListTableView.isHidden = true
                
                self.navigationBar.rightBtn.isEnabled = false
                self.navigationBar.rightBtn.setTitleColor(.gray300, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Output

extension NotificationBoxVC {
    
    private func getUserNotificationList() {
        viewModel.getUserNotificationList()
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
        var toPushVC = UIViewController()
        
        switch notificationBoxResponseModel?[indexPath.row].type {
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
            
        default:
            break
        }
        
        navigationController?.pushViewController(toPushVC, animated: true)
    }
    
}
