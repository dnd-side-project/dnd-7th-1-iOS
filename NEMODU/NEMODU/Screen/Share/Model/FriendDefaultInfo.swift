//
//  FriendDefaultInfo.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/16.
//

import Foundation

struct FriendDefaultInfo: Codable {
    let nickname: String
    let picturePath: String
}

extension FriendDefaultInfo {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}
