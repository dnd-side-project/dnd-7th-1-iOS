//
//  NotificationBoxResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/05/18.
//

import Foundation

// MARK: - NotificationBox ResponseModel

struct NotificationBoxElement: Codable {
    let title, content: String
    let messageId: String
    let isRead: Bool
    let type: String
    let reserved: String
}

typealias NotificationBoxResponseModel = [NotificationBoxElement]
