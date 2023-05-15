//
//  FriendStatusType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/30.
//

import UIKit

enum FriendStatusType: String {
    case accept = "ACCEPT" // 친구중
    case requesting = "REQUESTING" // 친구 요청중
    case responseWait = "RESPONSE_WAIT" // 수락 대기중
    case noFriend = "NO_FRIEND" // 친구 아님
    case reject = "REJECT"  // 친구 신청 거절
}

extension FriendStatusType {
    var isUserInteractionEnabled: Bool {
        switch self {
        case .accept, .responseWait:
            return false
        case .requesting, .noFriend:
            return true
        default:
            fatalError("무관")
        }
    }
    
    var isSelected: Bool? {
        switch self {
        case .requesting:
            return true
        case .noFriend:
            return false
        case .accept, .responseWait:
            return nil
        default:
            fatalError("무관")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .accept, .requesting, .responseWait:
            return .white
        case .noFriend:
            return .main
        default:
            fatalError("무관")
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .accept:
            return .main
        case .noFriend:
            return .white
        case .requesting, .responseWait:
            return .gray700
        default:
            fatalError("무관")
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .accept, .noFriend:
            return UIColor.main.cgColor
        case .requesting, .responseWait:
            return UIColor.gray700.cgColor
        default:
            fatalError("무관")
        }
    }
    
    var title: String {
        switch self {
        case .accept:
            return "친구중"
        case .requesting:
            return "친구 요청중"
        case .responseWait:
            return "수락 대기중"
        case .noFriend:
            return "친구 추가"
        default:
            fatalError("무관")
        }
    }
    
    var image: UIImage {
        switch self {
        case .accept:
            return UIImage(named: "check")!.withTintColor(.main,
                                                          renderingMode: .alwaysOriginal)
        case .requesting, .responseWait:
            return UIImage(named: "check")!.withTintColor(.gray700,
                                                          renderingMode: .alwaysOriginal)
        case .noFriend:
            return UIImage(named: "add")!.withTintColor(.white,
                                                        renderingMode: .alwaysOriginal)
        default:
            fatalError("무관")
        }
    }
}
