//
//  FriendDeleteRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/17.
//

import Foundation
import Alamofire

struct FriendDeleteRequestModel {
    let friendNickname: [String]
}

extension FriendDeleteRequestModel {
    var param: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "friendNickname": friendNickname,
            "userNickname": nickname
        ]
    }
}
