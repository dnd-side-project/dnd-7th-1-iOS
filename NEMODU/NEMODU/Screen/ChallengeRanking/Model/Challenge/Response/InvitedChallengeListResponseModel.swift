//
//  InvitedChallengeListResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/31.
//

import Foundation

struct InvitedChallengeListElement: Codable {
    let created, inviterNickname, message, name: String
    let picturePath, uuid: String
}

typealias InvitedChallengeListResponseModel = [InvitedChallengeListElement]
