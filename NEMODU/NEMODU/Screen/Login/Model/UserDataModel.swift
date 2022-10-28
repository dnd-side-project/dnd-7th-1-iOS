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
        // TODO: - 정보 공개 범위 화면 구현 후 데이터 연결
        return [
            "nickname": UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? fatalError(),
            "isPublicRecord": false,
            "kakaoRefreshToken": UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoRefreshToken) ?? fatalError(),
            "friends": friends
        ]
    }
}
