//
//  ProfileResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import Foundation

struct ProfileResponseModel: Codable {
    let allMatrixNumber, areas, rank: Int
    let intro, isFriend, lasted, nickname: String
    let picturePath: String
    let challenges: [ChallengeElementResponseModel]
}

extension ProfileResponseModel {
    var profileImageURL: URL? {
        guard let profileImageURL = picturePath.encodeURL() else { return nil }
        return URL(string: profileImageURL)
    }
}
