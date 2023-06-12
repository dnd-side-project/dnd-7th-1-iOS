//
//  NotificationCategoryType.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/08.
//

import Foundation

enum NotificationCategoryType: String {
    static let actionIdentifier = "action"
    
    // 공통
    case challengeWeekStart = "COMMON_WEEK_START" // 주차 시작 알림
    case challengeWeekEnd = "COMMON_WEEK_END" // 주차 종료 알림
    
    // 친구
    case friendRequest = "FRIEND_RECEIVED_REQUEST" // 친구 요청이 온 경우
    case friendAccept = "FRIEND_ACCEPT" // 상대가 (친구신청을) 승낙한 경우
    
    // 챌린지
    case challengeInvited = "CHALLENGE_RECEIVED_REQUEST" // 초대 받았을 때 (팀원)
    case challengeAccepted = "CHALLENGE_ACCEPTED" // 상대의 챌린지 수락(방장)
    case challengeStart = "CHALLENGE_START_SOON" // 챌린지 진행 알림
    case challengeCancelled = "CHALLENGE_CANCELED" // 챌린지 취소 알림
    case challengeResult = "CHALLENGE_RESULT" // 챌린지 결과 안내
    
    // FCM 토큰
    case fcmTokenReissue = "COMMON_REISSUE_FCM_TOKEN" // FCM 토큰 재발행 요청
}

extension NotificationCategoryType {
    var identifier: String {
        switch self {
        // 공통
        case .challengeWeekStart:
            return "COMMON_WEEK_START"
        case .challengeWeekEnd:
            return "COMMON_WEEK_END"
        // 친구
        case .friendRequest:
            return "FRIEND_RECEIVED_REQUEST"
        case .friendAccept:
            return "FRIEND_ACCEPT"
        // 챌린지
        case .challengeInvited:
            return "CHALLENGE_RECEIVED_REQUEST"
        case .challengeAccepted:
            return "CHALLENGE_ACCEPTED"
        case .challengeStart:
            return "CHALLENGE_START_SOON"
        case .challengeCancelled:
            return "CHALLENGE_CANCELED"
        case .challengeResult:
            return "CHALLENGE_RESULT"
        // FCM 토큰 갱신
        case .fcmTokenReissue:
            return "COMMON_REISSUE_FCM_TOKEN"
        }
    }
}

extension NotificationCategoryType {
    
    func getNotificationIconImageNamed(isRead: Bool) -> String? {
        switch self {
        case .challengeWeekStart,
            .challengeWeekEnd:
            return isRead ? "defaultThumbnail" : "nemodu_badge"
        case .friendRequest,
            .friendAccept:
            return isRead ? "frend_notification" : "frend_notification_badge"
        case .challengeInvited,
            .challengeAccepted,
            .challengeStart,
            .challengeCancelled,
            .challengeResult:
            return isRead ? "challenge_notification" : "challenge_notification_badge"
        case .fcmTokenReissue:
            return nil
        }
    }

}
