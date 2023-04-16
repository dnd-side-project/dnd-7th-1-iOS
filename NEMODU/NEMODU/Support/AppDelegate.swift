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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let nemoduTBC = window?.rootViewController as? NEMODUTBC
        
        let content = response.notification.request.content
        switch content.categoryIdentifier {
            // 친구 요청, 수락 시 마이페이지의 친구화면으로 전환
        case NotificationCategoryType.friendRequest.identifier,
            NotificationCategoryType.friendAccept.identifier:
            nemoduTBC?.selectedIndex = 2
            let mypageNC = nemoduTBC?.viewControllers?[2] as? MypageNC
            let mypageVC = mypageNC?.viewControllers[0] as? MypageVC
            
            let friendsVC = FriendsVC()
            friendsVC.hidesBottomBarWhenPushed = true
            mypageVC?.navigationController?.pushViewController(friendsVC, animated: true)
        
            // 초대, 수락, 시작 전, 취소된 챌린지의 상세화면으로 전환
        case NotificationCategoryType.challengeInvited.identifier,
            NotificationCategoryType.challengeAccepted.identifier,
            NotificationCategoryType.challengeStart.identifier,
            NotificationCategoryType.challengeCancelled.identifier:
            nemoduTBC?.selectedIndex = 0
            let challengeRankingNC = nemoduTBC?.viewControllers?[0] as? ChallengeRankingNC
            let challengeVC = challengeRankingNC?.viewControllers[0] as? ChallengeVC
            
            let invitedChallengeDetailVC = InvitedChallengeDetailVC()
            invitedChallengeDetailVC.hidesBottomBarWhenPushed = true

            invitedChallengeDetailVC.uuid = "11edd54eb4e38b67aac54d3b9a37e33f" // TODO: - reponse 내용 중 uuid값 추출 후 넘기는 작업 필요
            invitedChallengeDetailVC.getInvitedChallengeDetailInfo()
            
            challengeVC?.navigationController?.pushViewController(invitedChallengeDetailVC, animated: true)
            
            // 진행 완료 챌린지 상세화면으로 전환
        case NotificationCategoryType.challengeResult.identifier:
            nemoduTBC?.selectedIndex = 0
            let challengeRankingNC = nemoduTBC?.viewControllers?[0] as? ChallengeRankingNC
            let challengeVC = challengeRankingNC?.viewControllers[0] as? ChallengeVC
            
            let challengeHistoryDetailVC = ChallengeHistoryDetailVC()
            challengeHistoryDetailVC.hidesBottomBarWhenPushed = true
            challengeHistoryDetailVC.challgeStatus = "Done"
            
            challengeHistoryDetailVC.getChallengeHistoryDetailInfo(uuid: "11edd54eb4e38b67aac54d3b9a37e33f") // TODO: - 변경된 요청값 반영필요(nickname&uuid로 완료된 챌린지 조회)
            
            challengeVC?.navigationController?.pushViewController(challengeHistoryDetailVC, animated: true)
        default:
            break
        }
    }
    
}

// MARK: - Notification Setting

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
    
}

// MARK: - Firebase Messaging

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.set(fcmToken, forKey: UserDefaults.Keys.fcmToken)
    }
    
}
