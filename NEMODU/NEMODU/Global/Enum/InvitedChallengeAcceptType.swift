//
//  InvitedChallengeAcceptType.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/12/10.
//

import UIKit

/// 초대받은 챌린지 수락상태 타입 3가지(주최자, 대기중, 수락완료)
enum InvitedChallengeAcceptType: String {
    case master
    case wait
    case progress
    case reject
}

extension InvitedChallengeAcceptType {
    var statusText: String {
        switch self {
        case .master:
            return "주최자"
        case .wait:
            return "대기중"
        case .progress:
            return "수락 완료"
        case .reject:
            return "거절"
        }
    }
    
    var statusColor: UIColor {
        switch self {
        case .progress:
            return .main
        default:
            return .gray600
        }
    }
}

// MARK: - Custom String Convertible

extension InvitedChallengeAcceptType: CustomStringConvertible {
    var description: String {
        rawValue.uppercased()
    }
}
