//
//  ProfileResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import Foundation

struct ProfileResponseModel: Codable {
    let allMatrixNumber, areas, rank: Int
    let isFriend, lasted, nickname: String
    let intro: String?
    let picturePath: String
    let challenges: [ChallengeElementResponseModel]
}

extension ProfileResponseModel {
    var picturePathURL: URL? {
        guard let profileImageURL = picturePath.encodeURL() else { return nil }
        return URL(string: profileImageURL)
    }
}
