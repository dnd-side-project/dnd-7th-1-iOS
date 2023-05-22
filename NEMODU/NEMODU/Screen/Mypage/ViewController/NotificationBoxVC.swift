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
    
    // TODO: 서버연결 후 Dummy Data 삭제
    typealias NotificationListType = ((iconType: String, title: String, body: String, time:String, isRead: Bool))
    private let dummyData: [NotificationListType] = [("COMMON", "주차 시작 알림", "이번 주차 기록/챌린지가 자정에 곧 종료돼요.", "2023-05-04T16:50:00", false),
                                                     ("FRIEND", "혹시 자동차나 자전거를 타고 계신가요?", "속도가 너무 빠른 경우 기록이 일시정지됩니다. 앱을 켜서 확인해주세요.", "2023-05-04T1:50:00", false),
                                                     ("CHALLENGE", "'네모두네모두'님의 친구 요청", "회원님의 친구 수락을 기다리고 있어요", "2023-04-04T16:50:00", true),
                                                     ("RECORD", "챌린지가 이번 주차에 시작됩니다", "이번 주차 기록/챌린지가 자정에 곧 종료돼요.", "2022-05-04T16:50:00", true)]
    
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
        // TODO: 알림목록 조회 서버연결
    }
    
}

// MARK: - TableView DataSource

extension NotificationBoxVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count * 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListTVC.className, for: indexPath) as? NotificationListTVC else { return UITableViewCell() }
        cell.configureNotificationListTVC(dummyData: dummyData[indexPath.row % dummyData.count])
        
        return cell
    }
    
}

// MARK: - TableView Delegate

extension NotificationBoxVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row, " - 해당 알림과 관련된 화면으로 푸시")
    }
    
}
