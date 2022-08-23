//
//  DetailRecordDataResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/23.
//

import Foundation

struct DetailRecordDataResponseModel: Codable {
    let recordID: Int
    let date, started, ended: String
    let matrixNumber, stepCount, distance: Int
    let exerciseTime, message: String
    let matrices: [Matrix]
    let challenges: [Challenge]
}

// MARK: - Challenge
struct Challenge: Codable {
    let name, started, ended, color: String
}
