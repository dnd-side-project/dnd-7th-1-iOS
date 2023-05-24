//
//  LogoutRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/23.
//

import Foundation
import Alamofire

struct LogoutRequestModel: Codable {
    let deviceType, nickname: String
}

extension LogoutRequestModel {
    var param: Parameters {
        return [
            "nickname": nickname,
            "deviceType": deviceType
        ]
    }
}
