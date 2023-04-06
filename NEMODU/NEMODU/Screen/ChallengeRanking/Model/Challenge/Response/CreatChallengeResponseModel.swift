//
//  CreatChallengeResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/20.
//

import Foundation
import Alamofire

struct CreatChallengeResponseModel: Codable {
    let members: [Member]
    let message, started, ended: String
    let exceptMemberCount: Int
    let exceptMembers: [String]
}

// MARK: - Member

struct Member: Codable {
    let nickname: String
    let picturePath: String
}
