//
//  AppDelegate.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // SplashView 1초동안 보이게
        Thread.sleep(forTimeInterval: 1)
        
        NetworkMonitor.shared.startMonitoring()
        
        // FCM Push Notification Settings
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        requestNotificationSetting()
        application.registerForRemoteNotifications()
        
        // 카카오톡 Key 설정
        KakaoSDK.initSDK(appKey: "944b6ad264ad0085b68053652ee73b1b")
        
        // set rootViewController
        window = UIWindow()
        
        if UserDefaults.standard.string(forKey: UserDefaults.Keys.isFirstAccess) == nil {
            window?.rootViewController = OnboardingVC()
        } else if UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) == nil {
            // 신규 유저
            window?.rootViewController = LoginNC()
        } else {
            // 로그인 이력이 있는(자체 토큰을 가지고 있는) 유저
            window?.rootViewController = NEMODUTBC()
        }
        window?.makeKeyAndVisible()
         
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let action = userInfo[NotificationCategoryType.actionIdentifier] as? String else { return }
        
        if(action == NotificationCategoryType.fcmTokenReissue.identifier) {
            // TODO: FCM Token 갱신 서버코드 호출
            if let uuid: String = makeNotifiacatonUUID(userInfo: userInfo) {
                print("Notification UUID: ", uuid)
                // TODO: 알림 UUID 생성 후 수신 유무처리 서버에게 전송
            } else {
                print("failed to create Notification UUID!")
            }
        }
        
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        guard let action = userInfo[NotificationCategoryType.actionIdentifier] as? String else { return }
        
        var toGoTabVC = UIViewController()
        var toPushVC = UIViewController()
        
        switch action {
            // 친구 요청, 수락 시 마이페이지의 친구화면으로 전환
        case NotificationCategoryType.friendRequest.identifier,
            NotificationCategoryType.friendAccept.identifier:
            toGoTabVC = getTabIndexInstance(targetTabIndex: 2)
            
            let friendsVC = FriendsVC()
            friendsVC.hidesBottomBarWhenPushed = true
            
            toPushVC = friendsVC
            
            // 취소된 챌린지 알림 시, 메인화면으로 전환
        case NotificationCategoryType.challengeCancelled.identifier:
            toGoTabVC = getTabIndexInstance(targetTabIndex: 1)
            
            // 초대, 수락, 시작 전 챌린지의 상세화면으로 전환
        case NotificationCategoryType.challengeInvited.identifier,
            NotificationCategoryType.challengeAccepted.identifier,
            NotificationCategoryType.challengeStart.identifier:
            toGoTabVC = getTabIndexInstance(targetTabIndex: 0)
            
            guard let targetUUID = userInfo["challenge_uuid"] as? String else { return }
            
            let invitedChallengeDetailVC = InvitedChallengeDetailVC()
            invitedChallengeDetailVC.hidesBottomBarWhenPushed = true
            
            invitedChallengeDetailVC.uuid = targetUUID
            invitedChallengeDetailVC.getInvitedChallengeDetailInfo()
            
            toPushVC = invitedChallengeDetailVC
            
            // 진행 완료 챌린지 상세화면으로 전환
        case NotificationCategoryType.challengeResult.identifier:
            toGoTabVC = getTabIndexInstance(targetTabIndex: 0)
            
            guard let targetUUID = userInfo["challenge_uuid"] as? String else { return }
            
            let challengeHistoryDetailVC = ChallengeHistoryDetailVC()
            challengeHistoryDetailVC.hidesBottomBarWhenPushed = true
            challengeHistoryDetailVC.challgeStatus = "Done"
            
            challengeHistoryDetailVC.getChallengeHistoryDetailInfo(uuid: targetUUID)
            
            toPushVC = challengeHistoryDetailVC
            
        default:
            break
        }
        
        toGoTabVC.navigationController?.pushViewController(toPushVC, animated: true)
    }
    
}

// MARK: - 푸시알림(Notification) 관련 Functions

extension AppDelegate {
    
    /// 푸시알림 요청 보내기
    private func requestNotificationSetting() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
                self.checkNotificationSetting()
            }
        )
    }
    
    /// 디바이스 사용자의 푸시알림(Notification) 설정 상태 확인후 UserDefaults.isNotification에 값 설정
    private func checkNotificationSetting() {
        UNUserNotificationCenter.current()
            .getNotificationSettings { permission in
                switch permission.authorizationStatus {
                case .authorized,
                    .ephemeral,
                    .provisional:
                    UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isNotification)
                    
                case .denied,
                    .notDetermined:
                    UserDefaults.standard.set(false, forKey: UserDefaults.Keys.isNotification)
                    
                @unknown default:
                    UserDefaults.standard.set(false, forKey: UserDefaults.Keys.isNotification)
                }
            }
    }
    
    /// 서버에게 보낼 알림 고유 식별 ID(UUID) 반환
    private func makeNotifiacatonUUID(userInfo: [AnyHashable : Any]) -> String? {
        if let messageID = userInfo["gcm.message_id"] as? String {
            if let random = userInfo["random"] as? String {
                return messageID + random
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    private func getTabIndexInstance(targetTabIndex: Int) -> UIViewController {
        let nemoduTBC = window?.rootViewController as? NEMODUTBC
        nemoduTBC?.selectedIndex = targetTabIndex
        
        var targetIndexInstance = UIViewController()
        switch targetTabIndex {
        case 0:
            let challengeRankingNC = nemoduTBC?.viewControllers?[0] as? ChallengeRankingNC
            let challengeVC = challengeRankingNC?.viewControllers[0]
            targetIndexInstance = challengeVC ?? UIViewController()
        case 1:
            let mainVC = nemoduTBC?.viewControllers?[1] as? MainVC
            targetIndexInstance = mainVC ?? UIViewController()
        case 2:
            let mypageNC = nemoduTBC?.viewControllers?[2] as? MypageNC
            let mypageVC = mypageNC?.viewControllers[0]
            targetIndexInstance = mypageVC ?? UIViewController()
        default:
            targetIndexInstance = UIViewController()
        }
        
        return targetIndexInstance
    }
    
}

// MARK: - Firebase Messaging

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let curFCMToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.fcmToken) ?? ""
        if(curFCMToken != fcmToken) {
            // TODO: FCM Token 갱신 서버코드 호출
            UserDefaults.standard.set(fcmToken, forKey: UserDefaults.Keys.fcmToken)
        }
    }
    
}
