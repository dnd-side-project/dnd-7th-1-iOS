//
//  EventListRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/09.
//

import Foundation
import Alamofire

struct EventListRequestModel {
    var yearMonth: String
}

extension EventListRequestModel {
    var eventParam: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "nickname": nickname,
            "yearMonth": yearMonth
        ]
    }
}
