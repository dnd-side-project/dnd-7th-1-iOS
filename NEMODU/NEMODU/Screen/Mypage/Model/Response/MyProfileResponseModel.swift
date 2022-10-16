//
//  MyProfileResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import Foundation

struct MyProfileResponseModel: Codable {
    let nickname, intro, mail: String
    let picturePath: String
}
