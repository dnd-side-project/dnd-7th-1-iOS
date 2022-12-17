//
//  ProgressChallengeDetailResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/12/02.
//

import Foundation
import Alamofire

struct ProgressChallengeDetailResponseModel: Codable {
    let color: String
    let distance: Int
    let ended: String
    let exerciseTime: Int
    let matrices: [Matrix]
    let name: String
    let rankings: [Ranking]
    let started: String
    let stepCount: Int
    let type, uuid: String
}

// MARK: - Ranking
struct Ranking: Codable {
    let rank: Int
    let picturePath: String
    let nickname: String
    let score: Int
}
