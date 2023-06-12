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
    let isExceptRecommend: Bool
}

extension UserDataModel {
    var userDataParam: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname),
              let email = UserDefaults.standard.string(forKey: UserDefaults.Keys.email),
              let pictureName = UserDefaults.standard.string(forKey: UserDefaults.Keys.pictureName),
              let picturePath = UserDefaults.standard.string(forKey: UserDefaults.Keys.picturePath),
              let loginType = UserDefaults.standard.string(forKey: UserDefaults.Keys.loginType)
                // TODO: - fcmToken 처리
//              let fcmToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.fcmToken)
        else {
            // TODO: - 회원가입에 실패했습니다 알람 띄우기
            fatalError()
        }
        
        var parameter: Parameters = [
            "deviceType": FCMTokenManagement.shared.getDeviceType(),
            "nickname": nickname,
            "email": email,
            "friends": friends,
            "isPublicRecord": isPublicRecord,
            "loginType": loginType,
            "pictureName": pictureName,
            "picturePath": picturePath,
            "fcmToken": UserDefaults.standard.string(forKey: UserDefaults.Keys.fcmToken) ?? "",
            "isNotification": UserDefaults.standard.bool(forKey: UserDefaults.Keys.isNotification),
            "isExceptRecommend": isExceptRecommend
        ]
        
        if loginType == LoginType.kakao.rawValue,
           let kakaoUserId = UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoUserID) {
            parameter.merge(["socialId": kakaoUserId])
        }
        
        return parameter
    }
}
