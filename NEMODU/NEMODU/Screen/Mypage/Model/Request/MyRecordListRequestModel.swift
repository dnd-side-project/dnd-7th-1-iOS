//
//  MyRecordListRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/22.
//

import Foundation
import Alamofire

struct MyRecordListRequestModel {
    var start: String
    var end: String
}

extension MyRecordListRequestModel {
    var recordParam: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "end": end,
            "nickname": nickname,
            "start": start
        ]
    }
}
