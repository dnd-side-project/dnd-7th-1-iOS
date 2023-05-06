//
//  NotificationListIcon.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/05/04.
//

import UIKit

enum NotificationListIcon: String {
    case common
    case friend
    case challenge
    case record
}

extension NotificationListIcon {
    func getNotificationIconImageNamed(isRead: Bool) -> String {
        switch self {
        case .common:
            return isRead ? "defaultThumbnail" : "nemodu_badge"
        case .friend:
            return isRead ? "frend_notification" : "frend_notification_badge"
        case .challenge:
            return isRead ? "challenge_notification" : "challenge_notification_badge"
        case .record:
            return isRead ? "record_notification" : "record_notification_badge"
        }
    }
}

// MARK: - Custom String Convertible

extension NotificationListIcon: CustomStringConvertible {
    var description: String {
        rawValue.uppercased()
    }
}
