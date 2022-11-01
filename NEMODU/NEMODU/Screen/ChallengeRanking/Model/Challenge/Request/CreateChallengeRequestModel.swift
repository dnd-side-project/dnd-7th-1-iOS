//
//  CreateChallengeRequestModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/26.
//

import Foundation
import Alamofire

struct CreateChallengeRequestModel: Codable {
    var friends: [String]
    var message, name, nickname, started: String
    let type: String
}

extension CreateChallengeRequestModel {
    var createChallenge: Parameters {
        return [
          "friends": friends,
          "message": message,
          "name": name,
          "nickname": nickname,
          "started": started,
          "type": type
        ]
    }
}
