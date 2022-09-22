//
//  UserDataModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/14.
//

import Foundation
import Alamofire

struct UserDataModel {
    let friends: [String]
}

extension UserDataModel {
    var userDataParam: Parameters {
        return [
            // TODO: - 재로그인 API 추가 후 수정
//            "nickname": UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? fatalError()
            "nickname": UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? "아아",
            "kakaoRefreshToken": UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoRefreshToken) ?? fatalError(),
            "friends": friends
        ]
    }
}
