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
            "nickname": UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? fatalError(),
            "kakaoRefreshToken": UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoRefreshToken) ?? fatalError(),
            "friends": friends
        ]
    }
}
