//
//  MainMapResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/17.
//

import Foundation

struct MainMapResponseModel: Codable {
    let userMatrices: UserBlockResponseModel?
    let friendMatrices: [UserBlockResponseModel]?
    let challengeMatrices: [ChallengeBlockResponseModel]?
    let challengesNumber: Int
    let isShowMine: Bool
    let isShowFriend: Bool
    let isPublicRecord: Bool
}
