//
//  ChallengeDetailMapResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/01/21.
//

import Foundation

// MARK: - ChallengeDetailMap ResponseModel

struct ChallengeDetailMapResponseModel: Codable {
    let matrixList: [MatrixList]
    let rankingList: [RankingList]
}

// MARK: - MatrixList

struct MatrixList: Codable {
    let nickname: String
    let color: String
    let latitude, longitude: Double?
    let matrices: [Matrix]
    let picturePath: String
}

// MARK: - RankingList

struct RankingList: Codable {
    let nickname, picturePath: String
    let rank, score: Int
}

extension RankingList {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}
