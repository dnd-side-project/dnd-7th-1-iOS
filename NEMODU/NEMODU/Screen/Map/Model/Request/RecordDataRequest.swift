//
//  RecordDataRequest.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/19.
//

import Foundation
import Alamofire

struct RecordDataRequest {
    var distance: Int
    var exerciseTime: Int
    var blocks: [[Double]]
    var stepCount: Int
    var message: String?
}

extension RecordDataRequest {
    var recordParam: Parameters {
        // TODO: UserDefaults 수정
        return [
            "nickname": "NickA",
            "distance": distance,
            "exerciseTime": exerciseTime,
            "matrices": blocks,
            "stepCount": stepCount,
            "message": message ?? ""
        ]
    }
}
