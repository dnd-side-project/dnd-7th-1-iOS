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
    let isPublicRecord: Bool
}

extension UserDataModel {
    var userDataParam: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname),
              let email = UserDefaults.standard.string(forKey: UserDefaults.Keys.email),
              let pictureName = UserDefaults.standard.string(forKey: UserDefaults.Keys.pictureName),
              let picturePath = UserDefaults.standard.string(forKey: UserDefaults.Keys.picturePath),
              let loginType = UserDefaults.standard.string(forKey: UserDefaults.Keys.loginType)
        else { fatalError() }
        return [
            "nickname": nickname,
            "email": email,
            "friends": friends,
            "isPublicRecord": isPublicRecord,
            "logintype": loginType,
            "pictureName": pictureName,
            "picturePath": picturePath
        ]
    }
}
