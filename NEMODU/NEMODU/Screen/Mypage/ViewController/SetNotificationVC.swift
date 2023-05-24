//
//  SetNotificationVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/08.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SetNotificationVC: BaseViewController {
    
    // MARK: - UI components
    
    private let navigationBar = NavigationBar()
    
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }
    private let settingListStackView = UIStackView()
        .then {
            $0.spacing = 0
            $0.axis = .vertical
            $0.distribution = .fill
        }
    
    private let newWeekTitleLabelView = SettingItemTitleLabelView()
        .then {
            $0.setTitle(settingItemTitle: "새로운 주차 알림")
        }
    private let newWeekStartToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("시작 알림")
            $0.setMessage("새로운 기록이 시작되는 날 아침 9시에 알려드려요.")
        }
    private let newWeekEndToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("종료 알림")
            $0.setMessage("기록이 리셋되는 전날 21시에 알려드려요.")
        }
    
    private let friendTitleLabelView = SettingItemTitleLabelView()
        .then {
            $0.setTitle(settingItemTitle: "친구 알림")
        }
    private let friendRequestToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("요청 알림")
            $0.setMessage("친구 요청이 온 경우 알려드려요.")
        }
    private let friendAcceptToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("수락 알림")
            $0.setMessage("상대가 내 요청을 수락한 경우 알려드려요.")
        }
    
    private let challengeTitleLabelView = SettingItemTitleLabelView()
        .then {
            $0.setTitle(settingItemTitle: "챌린지 알림")
        }
    private let challengeInviteToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("초대 알림")
            $0.setMessage("친구에게 챌린지 초대가 온 경우 알려드려요.")
        }
    private let challengeAcceptToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("수락 알림")
            $0.setMessage("친구가 나의 챌린지 초대를 승낙한 경우 알려드려요.")
        }
    private let challengeProgressToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("진행 알림")
            $0.setMessage("내가 만든 챌린지가 진행되는 경우 알려드려요.")
        }
    private let challengeCancelToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("취소 알림")
            $0.setMessage("내가 만든 챌린지가 취소되는 경우 알려드려요.")
        }
    private let challengeResultToggleButtonView = ToggleButtonView()
        .then {
            $0.setTitle("결과 알림")
            $0.setMessage("챌린지 종료 후, 결과에 대해 알려드려요.")
        }
    
    // MARK: - Variables and Properties
    
    private let viewModel = SetNotificationVM()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
    
        checkUserNotificationEnabled()
        configureNavigationBar()
        configureSettingListStackView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindNotificationToggleButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindAPIErrorAlert(viewModel)
        bindUserNotificationSettings()
    }
    
}

// MARK: - Configure

extension SetNotificationVC {
    
    private func checkUserNotificationEnabled() {
        UNUserNotificationCenter.current()
            .getNotificationSettings { permission in
                switch permission.authorizationStatus {
                case .authorized,
                    .ephemeral,
                    .provisional:
                    self.viewModel.getUserNotificationSettings()
                    
                case .denied,
                    .notDetermined:
                    self.setDisabledNotificationSettings()
                    
                @unknown default:
                    break
                }
        }
    }
    
    private func setDisabledNotificationSettings() {
        DispatchQueue.main.async { [self] in
            for subview in settingListStackView.subviews {
                if let toggleButton = subview as? ToggleButtonView {
                    toggleButton.toggleBtn.isOn = false
                }
            }
            settingListStackView.isUserInteractionEnabled = false
            settingListStackView.alpha = 0.5
        }
    }
    
    private func setUserNotificaionSettings(userSettings: SetNotificationResponseModel) {
        // 새로운 주차 알림
        newWeekStartToggleButtonView.toggleBtn.isOn = userSettings.notiWeekStart
        newWeekEndToggleButtonView.toggleBtn.isOn = userSettings.notiWeekEnd
        // 친구 알림
        friendRequestToggleButtonView.toggleBtn.isOn = userSettings.notiFriendRequest
        friendAcceptToggleButtonView.toggleBtn.isOn = userSettings.notiFriendAccept
        // 챌린지 알림
        challengeInviteToggleButtonView.toggleBtn.isOn = userSettings.notiChallengeRequest
        challengeAcceptToggleButtonView.toggleBtn.isOn = userSettings.notiChallengeAccept
        challengeProgressToggleButtonView.toggleBtn.isOn = userSettings.notiChallengeStart
        challengeCancelToggleButtonView.toggleBtn.isOn = userSettings.notiChallengeCancel
        challengeResultToggleButtonView.toggleBtn.isOn = userSettings.notiChallengeResult
    }
    
    private func configureNavigationBar() {
        navigationBar.naviType = .push
        navigationBar.configureNaviBar(targetVC: self,
                                 title: "알림 설정")
        navigationBar.configureBackBtn(targetVC: self)
    }
    
    private func configureSettingListStackView() {
        [newWeekTitleLabelView, friendTitleLabelView, challengeTitleLabelView].forEach { titleLabelView in
            // 제목과 토글버튼 목록을 담을 BaseView 선언
            let baseView = UIView()
            
            // 알림 대분류 항목(titleLabelView) 제목 추가
            baseView.addSubview(titleLabelView)
            titleLabelView.snp.makeConstraints {
                $0.top.horizontalEdges.equalTo(baseView)
            }
            
            // 알림 대분류 하위항목(toggleButonView) 목록의 토글버튼 추가
            let toggleButtonViewListStackView = UIStackView()
                .then {
                    $0.spacing = 0
                    $0.axis = .vertical
                    $0.distribution = .fillEqually
                }
            var toggleButtonViewList: [ToggleButtonView] = []
            switch titleLabelView {
            case newWeekTitleLabelView:
                toggleButtonViewList = [newWeekStartToggleButtonView,
                                        newWeekEndToggleButtonView]
            case friendTitleLabelView:
                toggleButtonViewList = [friendRequestToggleButtonView,
                                        friendAcceptToggleButtonView]
            case challengeTitleLabelView:
                toggleButtonViewList = [challengeInviteToggleButtonView,
                                        challengeAcceptToggleButtonView,
                                        challengeProgressToggleButtonView,
                                        challengeCancelToggleButtonView,
                                        challengeResultToggleButtonView]
            default:
                break
            }
            toggleButtonViewList.forEach { toggleButtonView in
                toggleButtonViewListStackView.addArrangedSubview(toggleButtonView)
            }
            
            baseView.addSubview(toggleButtonViewListStackView)
            toggleButtonViewListStackView.snp.makeConstraints {
                $0.top.equalTo(titleLabelView.snp.bottom).offset(16.0)
                $0.horizontalEdges.bottom.equalTo(baseView).inset(16.0)
            }
            
            // 전체 알림 목록에 추가
            settingListStackView.addArrangedSubview(baseView)
        }
    }
    
}

// MARK: - Layout

extension SetNotificationVC {
    
    private func configureLayout() {
        view.addSubviews([baseScrollView])
        baseScrollView.addSubviews([settingListStackView])

        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
        settingListStackView.snp.makeConstraints {
            $0.width.equalTo(view.frame.size.width)
            
            $0.top.bottom.equalTo(baseScrollView)
        }
    }
    
}

// MARK: - Input

extension SetNotificationVC {
    
    private func bindNotificationToggleButton() {
        typealias BindList = (toggleButton: ToggleButtonView, notificationType: NotificationCategoryType)
        let toggleButtonList: [BindList] = [(newWeekStartToggleButtonView, .challengeWeekStart), (newWeekEndToggleButtonView, .challengeWeekEnd),
                                            (friendRequestToggleButtonView, .friendRequest), (friendAcceptToggleButtonView, .friendAccept),
                                            (challengeInviteToggleButtonView, .challengeInvited), (challengeAcceptToggleButtonView, .challengeAccepted), (challengeProgressToggleButtonView, .challengeStart), (challengeCancelToggleButtonView, .challengeCancelled), (challengeResultToggleButtonView, .challengeResult)]
        
        toggleButtonList.forEach { target in
            target.toggleButton.toggleBtn.rx.isOn
                .changed
                .withUnretained(self)
                .subscribe(onNext: { owner, status in
                    owner.viewModel.updateNotificationSetting(notificationType: target.notificationType)
                })
                .disposed(by: disposeBag)
        }
    }
    
}

// MARK: - Output

extension SetNotificationVC {
    
    private func bindUserNotificationSettings() {
        viewModel.output.userNotificationSettings
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.setUserNotificaionSettings(userSettings: data)
            })
            .disposed(by: disposeBag)
    }
    
}
