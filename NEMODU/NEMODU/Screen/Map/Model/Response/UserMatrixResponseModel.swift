//
//  UserMatrixResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/01.
//

import Foundation

struct UserMatrixResponseModel: Codable {
    let matrices: [Matrix]
    let nickname: String
}
