//
//  CreatChallengeResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/20.
//

import Foundation
import Alamofire

struct CreatChallengeResponseModel: Codable {
    let users: [ChallengeUser]
    let message, started, ended: String
}

// MARK: - User

struct ChallengeUser: Codable {
    let nickname: String
    let picturePath: String
}
