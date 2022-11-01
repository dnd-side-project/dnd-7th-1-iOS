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
    let recordID, matrixNumber, stepCount, distance: Int
    let exerciseTime, started: String

    enum CodingKeys: String, CodingKey {
        case recordID = "recordId"
        case matrixNumber, stepCount, distance, exerciseTime, started
    }
}
