//
//  FriendRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/04/30.
//

import Foundation
import Alamofire

struct FriendRequestModel {
    let friendNickname: String
}

extension FriendRequestModel {
    var param: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "friendNickname": friendNickname,
            "userNickname": nickname
        ]
    }
}
