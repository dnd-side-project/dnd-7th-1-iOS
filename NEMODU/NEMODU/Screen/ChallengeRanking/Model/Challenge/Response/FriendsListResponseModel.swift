//
//  FriendsListResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/01.
//

import Foundation
import Alamofire

struct FriendsListResponseModel: Codable {
    let infos: [Info]
    let isLast: Bool
    let size: Int
}

// MARK: - Info

struct Info: Codable {
    let nickname, picturePath: String
}

extension Info {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}
