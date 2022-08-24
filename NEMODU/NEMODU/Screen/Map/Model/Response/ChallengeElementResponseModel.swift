//
//  ChallengeElementResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import Foundation

struct ChallengeElementResponseModel: Codable {
    let name, started, ended: String
    let rank: Int?
    let color: String
}
