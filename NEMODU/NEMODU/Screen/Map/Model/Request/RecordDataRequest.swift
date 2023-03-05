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
    var matrices: [Matrix]
    var stepCount: Int
    var message: String?
    let started: String
    let ended: String
}

extension RecordDataRequest {
    var recordParam: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "nickname": nickname,
            "distance": distance,
            "exerciseTime": exerciseTime,
            "matrices": getJSONSerialization(from: matrices),
            "stepCount": stepCount,
            "message": message ?? "",
            "started": started,
            "ended": ended
        ]
    }
    
    func getJSONSerialization(from matrices: [Matrix]) -> [[String: Double]] {
        var data = [[String: Double]]()
        matrices.forEach {
            data.append( [
                "latitude": $0.latitude,
                "longitude": $0.longitude
            ] )
        }
        return data
    }
}
