//
//  AcceptRejectChallengeRequestModel.swift
//  NEMODU
//
//  Created by Kennadi on 2022/11/01.
//

import Foundation
import Alamofire

struct AcceptRejectChallengeRequestModel: Codable {
    let nickname, uuid: String
}

extension AcceptRejectChallengeRequestModel {
    var acceptRejectChallenge: Parameters {
        return [
          "nickname": nickname,
          "uuid": uuid
        ]
    }
}
