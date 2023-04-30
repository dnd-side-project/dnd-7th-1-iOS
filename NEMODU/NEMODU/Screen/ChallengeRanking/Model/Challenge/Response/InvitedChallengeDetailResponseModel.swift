//
//  InvitedChallengeDetailResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/12/10.
//

import Foundation

struct InvitedChallengeDetailResponseModel: Codable {
    let name, type, color, started: String
    let ended: String
    let infos: [InvitedChallengeDetailInfo]
}

// MARK: - InvitedChallengeDetailInfo Info

struct InvitedChallengeDetailInfo: Codable {
    let picturePath, nickname, status: String
}

extension InvitedChallengeDetailInfo {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}
