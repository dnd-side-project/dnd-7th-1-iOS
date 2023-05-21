//
//  MyRecordListResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/22.
//

import Foundation

struct MyRecordListResponseModel: Codable {
    let activityRecords: [ActivityRecord]
}

struct ActivityRecord: Codable {
    let recordID: Int
    let matrixNumber: Int
    let stepCount: Int
    let distance: Int
    let exerciseSecond: Int
    let started: String

    enum CodingKeys: String, CodingKey {
        case recordID = "recordId"
        case exerciseSecond = "exerciseTime"
        case matrixNumber, stepCount, distance, started
    }
}
