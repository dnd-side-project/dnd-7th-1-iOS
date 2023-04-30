//
//  AccumulateRankingListResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/23.
//

import Foundation
import Alamofire

struct AccumulateRankingListResponseModel: Codable {
    let matrixRankings: [MatrixRanking]
}

// MARK: - MatrixRanking

struct MatrixRanking: Codable {
    let rank: Int
    let nickname: String
    let score: Int
    let picturePath: String
}

extension MatrixRanking {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}
