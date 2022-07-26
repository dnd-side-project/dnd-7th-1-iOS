//
//  ChallengeColorType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import UIKit

enum ChallengeColorType: String {
    case red = "Red"
    case pink = "Pink"
    case yellow = "Yellow"
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
        }
    }
}
