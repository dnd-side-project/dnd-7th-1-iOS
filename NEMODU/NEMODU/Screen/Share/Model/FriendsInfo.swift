//
//  FriendsInfo.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/14.
//

import Foundation

struct FriendsInfo: Codable {
    let nickname: String
    let picturePath: String
    let kakaoName: String?
    let status: String?
}

extension FriendsInfo {
    var picturePathURL: URL? {
        guard let profileImageURL = picturePath.encodeURL() else { return nil }
        return URL(string: profileImageURL)
    }
}
