//
//  UserDefaults+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/28.
//

import Foundation

extension UserDefaults {
    enum Keys {
        static var nickname = "nickname"
        static var isFirstAccess = "isFirstAccess"
        static var accessToken = "accessToken"
        static var refreshToken = "refreshToken"
        static var kakaoAccessToken = "kakaoAccessToken"
        static var kakaoRefreshToken = "kakaoRefreshToken"
        static var appleToken = "appleToken"
    }
}
