//
//  MypageUserDataResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/21.
//

import Foundation

struct MypageUserDataResponseModel: Codable {
    let nickname, picturePath: String
    let intro: String?
    let matrixNumber, stepCount, distance, friendNumber: Int
    let allMatrixNumber: Int
}

extension MypageUserDataResponseModel {
    var profileImageURL: URL? {
        guard let profileImageURL = picturePath.encodeURL() else { return nil }
        return URL(string: profileImageURL)
    }
}
