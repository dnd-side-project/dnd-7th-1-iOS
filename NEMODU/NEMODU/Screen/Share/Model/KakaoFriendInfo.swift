//
//  KakaoFriendInfo.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/23.
//

import Foundation

struct KakaoFriendInfo: Codable {
    let isSigned: Bool
    let kakaoNickname, nickname: String
    let picturePath: String
    let uuid: String
}

extension KakaoFriendInfo {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}
