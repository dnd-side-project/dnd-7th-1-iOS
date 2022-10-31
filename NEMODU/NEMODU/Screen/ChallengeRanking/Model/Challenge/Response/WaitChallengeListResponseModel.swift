//
//  ChallengeWaitResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/30.
//

import Foundation

struct WaitChallengeListElement: Codable {
    let name, uuid, started, ended: String
    let totalCount, readyCount: Int
    let color: String
    let picturePaths: [String]
}

typealias WaitChallengeListResponseModel = [WaitChallengeListElement]
