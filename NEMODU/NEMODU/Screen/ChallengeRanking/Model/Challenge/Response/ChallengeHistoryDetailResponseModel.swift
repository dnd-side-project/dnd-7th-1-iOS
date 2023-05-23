//
//  ChallengeHistoryDetailResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/12/02.
//

import Foundation
import Alamofire

struct ChallengeHistoryDetailResponseModel: Codable {
    let uuid: String
    let name: String
    let type: String
    let started, ended: String
    let color: String
    let distance: Int
    let exerciseTime: Int
    let stepCount: Int
    let latitude, longitude: Double
    let matrices: [Matrix]
    let rankings: [Ranking]
}

// MARK: - Ranking

struct Ranking: Codable {
    let rank: Int
    let picturePath: String
    let nickname: String
    let score: Int
}

extension Ranking {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}

