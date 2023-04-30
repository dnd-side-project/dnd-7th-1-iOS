//
//  UpdateNotificationSettingRequestModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/20.
//

import Foundation
import Alamofire

struct UpdateNotificationSettingRequestModel: Codable {
    let nickname, notification: String
}

extension UpdateNotificationSettingRequestModel {
    var param: Parameters {
        return [
            "nickname": nickname,
            "notification": notification
        ]
    }
}
