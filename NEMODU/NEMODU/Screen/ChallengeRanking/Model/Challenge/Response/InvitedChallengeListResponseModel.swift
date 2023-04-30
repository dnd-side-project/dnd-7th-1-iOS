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

extension InvitedChallengeListElement {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}

typealias InvitedChallengeListResponseModel = [InvitedChallengeListElement]
