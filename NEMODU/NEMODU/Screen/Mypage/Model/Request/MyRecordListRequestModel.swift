//
//  MyRecordListRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/22.
//

import Foundation
import Alamofire

struct MyRecordListRequestModel {
    var started: String
    var ended: String
}

extension MyRecordListRequestModel {
    var recordParam: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "nickname": nickname,
            "started": started,
            "ended": ended
        ]
    }
}
