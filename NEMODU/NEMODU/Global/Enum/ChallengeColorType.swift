//
//  ChallengeColorType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import UIKit

enum ChallengeColorType: String {
    case red = "RED"
    case pink = "PINK"
    case yellow = "YELLOW"
    case green = "GREEN"
}

extension ChallengeColorType {
    var primaryColor: UIColor {
        switch self {
        case .red:
            return .red100
        case .pink:
            return .pink100
        case .yellow:
            return .yellow100
        case .green:
            return .main
        }
    }
    
    var blockColor: UIColor {
        switch self {
        case .red:
            return .red30
        case .pink:
            return .pink25
        case .yellow:
            return .yellow20
        case .green:
            return .main40
        }
    }
}
