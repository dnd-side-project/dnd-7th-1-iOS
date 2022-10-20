//
//  RankingListRequestModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/22.
//

import Foundation
import Alamofire

struct RankingListRequestModel {
    var end: String
    var nickname: String
    var start: String
}

extension RankingListRequestModel {
    // TODO: UserDefaults 수정
    var areaParam: Parameters {
        return [
            "end": end,
            "nickname": nickname,
            "start": start
        ]
    }
}
