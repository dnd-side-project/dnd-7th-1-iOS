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
    // TODO: - User Defaults 수정
    var recordParam: Parameters {
        return [
            "end": end,
            "nickname": "NickA",
            "start": start
        ]
    }
}
