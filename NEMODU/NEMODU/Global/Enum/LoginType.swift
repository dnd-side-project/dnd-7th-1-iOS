//
//  LoginType.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/01/31.
//

import Foundation

enum LoginType: String {
    case apple = "APPLE"
    case kakao = "KAKAO"
}

extension LoginType {
    // TODO: - 토큰 없는 경우 fatalError 대신 로그인 화면으로 이동
    var token: String {
        switch self {
        case .apple:
            guard let token = UserDefaults.standard.string(forKey: UserDefaults.Keys.appleToken)
            else { fatalError() }
            return token
        case .kakao:
            guard let token = UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoAccessToken)
            else { fatalError() }
            return token
        }
    }
}
