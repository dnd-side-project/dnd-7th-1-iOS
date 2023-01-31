//
//  MyProfileResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import Foundation

struct MyProfileResponseModel: Codable {
    let nickname, mail: String
    let intro: String?
    let picturePath: String
}

extension MyProfileResponseModel {
    var profileImageURL: URL? {
        guard let profileImageURL = picturePath.encodeURL() else { return nil }
        return URL(string: profileImageURL)
    }
}
