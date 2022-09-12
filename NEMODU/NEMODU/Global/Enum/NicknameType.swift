//
//  NicknameType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/12.
//

import UIKit

enum NicknameType {
    case countError
    case notAvailable
    case available
}

extension NicknameType {
    var message: String {
        switch self {
        case .countError:
            return "닉네임은 2자 이상 ~ 6자 이하로 설정해주세요."
        case .notAvailable:
            return "이미 사용중인 닉네임입니다."
        case .available:
            return "닉네임으로 사용하실 수 있습니다."
        }
    }
    
    var image: UIImage {
        switch self {
        case .countError, .notAvailable:
            return UIImage(named: "warning_Red") ?? UIImage()
        case .available:
            return UIImage(named: "check_main") ?? UIImage()
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .countError, .notAvailable:
            return .red100
        case .available:
            return .main
        }
    }
}
