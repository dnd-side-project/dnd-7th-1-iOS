//
//  UpdateFCMTokenRequestModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/05/24.
//

import Foundation
import Alamofire

struct UpdateFCMTokenRequestModel: Codable {
    let deviceType, fcmToken, nickname: String
}

extension UpdateFCMTokenRequestModel {
    var param: Parameters {
        return [
            "deviceType": deviceType,
            "fcmToken": fcmToken,
            "nickname": nickname
        ]
    }
}
