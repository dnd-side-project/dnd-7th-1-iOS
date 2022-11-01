//
//  MypageUserDataResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/21.
//

import Foundation

struct MypageUserDataResponseModel: Codable {
    let nickname, intro, picturePath: String
    let matrixNumber, stepCount, distance, friendNumber: Int
    let allMatrixNumber: Int
}
