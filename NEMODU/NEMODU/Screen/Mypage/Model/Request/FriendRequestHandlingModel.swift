//
//  FriendRequestHandlingModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/15.
//

import Foundation
import Alamofire

// Request & Response Model
struct FriendRequestHandlingModel: Codable {
    let userNickname: String?
    let friendNickname: String
    let status: String
    
    init(friendNickname: String, status: String) {
        self.userNickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)
        self.friendNickname = friendNickname
        self.status = status
    }
}

extension FriendRequestHandlingModel {
    var param: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "userNickname": nickname,
            "friendNickname": friendNickname,
            "status": status
        ]
    }
}
