//
//  NotificationCategoryType.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/08.
//

import Foundation

enum NotificationCategoryType {
    // 친구
    case friendRequest // 친구 요청이 온 경우
    case friendAccept // 상대가 (친구신청을) 승낙한 경우
    // 챌린지
    case challengeInvited // 초대 받았을 때 (팀원)
    case challengeAccepted // 상대의 챌린지 수락(방장)
    case challengeStart // 챌린지 진행 알림
    case challengeCancelled // 챌린지 취소 알림
    case challengeResult // 챌린지 결과 안내
}

extension NotificationCategoryType {
    var identifier: String {
        switch self {
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
        }
    }
}
