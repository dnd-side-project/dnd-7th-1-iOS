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
    var blocks: [Matrix]
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
            "matrices": changeMatriesToBlocks(matrices: blocks),
            "stepCount": stepCount,
            "message": message ?? "",
            "started": started,
            "ended": ended
        ]
    }
    
    /// [Matrix]형 모델을 [[Double]]형 blocks로 변환해주는 함수
    func changeMatriesToBlocks(matrices: [Matrix]) -> [[Double]] {
        var blocks: [[Double]] = []
        matrices.forEach {
            blocks.append([$0.latitude, $0.longitude])
        }
        return blocks
    }
}
