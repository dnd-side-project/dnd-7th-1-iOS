//
//  DateType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/04.
//

import Foundation

enum DateType {
    case withTime
    case hyphen
    case withT
}

extension DateType {
    var dateFormatter: String {
        switch self {
        case .hyphen:
            return "yyyy-MM-dd"
        case .withTime:
            return "yyyy-MM-dd'T'HH:mm:ss"
        case .withT:
            return "yyyy-MM-dd'T'"
        }
    }
}
