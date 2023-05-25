//
//  RemoveNotificationListRequestModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/05/22.
//

import Foundation
import Alamofire

// MARK: - RemoveNotificationList RequestModel

struct RemoveNotificationListRequestModel: Codable {
    let notifications: [String]
}

extension RemoveNotificationListRequestModel {
    var removeNotificationList: Parameters {
        return [
          "notifications": notifications
        ]
    }
}
