//
//  UserBlockResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import Foundation

struct UserBlockResponseModel: Codable {
    let nickname: String
    let latitude, longitude: Double
    let matrices: [Matrix]
    let matricesNumber: Int?
}
