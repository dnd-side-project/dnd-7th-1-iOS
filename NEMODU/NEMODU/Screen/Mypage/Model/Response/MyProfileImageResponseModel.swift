//
//  MyProfileImageResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/23.
//

import Foundation

struct MyProfileImageResponseModel: Codable {
    let nickname, picturePath: String
}

extension MyProfileImageResponseModel {
    var picturePathURL: URL? {
        guard let picturePathURL = picturePath.encodeURL() else { return nil }
        return URL(string: picturePathURL)
    }
}
