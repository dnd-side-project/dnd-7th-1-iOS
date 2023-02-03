//
//  SocialLoginResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/01/31.
//

import Foundation

struct SocialLoginResponseModel: Codable {
    let email: String
    let picturePath: String
    let pictureName: String
    let signed: Bool
}
