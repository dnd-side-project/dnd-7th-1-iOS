//
//  CreateChallengeRequestModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/26.
//

import Foundation

struct CreateChallengeRequestModel: Codable {
    var friends: [String]
    var message, name, nickname, started: String
    var type: String
}
