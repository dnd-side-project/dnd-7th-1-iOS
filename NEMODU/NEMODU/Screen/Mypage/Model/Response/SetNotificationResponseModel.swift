//
//  SetNotificationResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/18.
//

import Foundation

// MARK: - SetNotification ResponseModel

struct SetNotificationResponseModel: Codable {
    // 새로운 주차 알림
    let notiWeekStart, notiWeekEnd: Bool
    // 친구 알림
    let notiFriendRequest, notiFriendAccept: Bool
    // 챌린지 알림
    let notiChallengeRequest, notiChallengeAccept, notiChallengeStart, notiChallengeCancel,  notiChallengeResult: Bool
}
