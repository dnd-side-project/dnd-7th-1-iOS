//
//  StepRankingListResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/22.
//

import Foundation
import Alamofire

struct StepRankingListResponseModel: Codable {
    let stepRankings: [StepRanking]
}

// MARK: - StepRanking

struct StepRanking: Codable {
    let nickname, picturePath: String
    let rank, score: Int
}
