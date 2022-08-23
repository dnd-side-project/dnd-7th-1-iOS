//
//  AreaRankingListResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/22.
//

import Foundation
import Alamofire

struct AreaRankingListResponseModel: Codable {
    let areaRankings: [AreaRanking]
}

// MARK: - AreaRanking

struct AreaRanking: Codable {
    let nickname: String
    let rank, score: Int
}
