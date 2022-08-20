//
//  ProfileResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import Foundation

struct ProfileResponseModel: Codable {
    let nickname, lasted, intro: String
    let isFriend: Bool
    let areas, allMatrixNumber, rank: Int
    let challenges: [ChallengeElementResponseModel]
}
