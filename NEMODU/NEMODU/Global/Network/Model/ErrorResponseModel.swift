//
//  ErrorResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/19.
//

import Foundation

struct ErrorResponseModel: Codable {
    let code: String?
    let message: String?
    let trace: [String]?
}
