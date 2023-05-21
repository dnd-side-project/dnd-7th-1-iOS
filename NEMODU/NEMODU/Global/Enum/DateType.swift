//
//  DateType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/04.
//

import Foundation

enum DateType {
    /// yyyy-MM-dd'T'HH:mm:ss
    case withTime
    /// yyyy-MM-dd
    case hyphen
    /// yyyy-MM-dd'T'
    case withT
    /// yyyy-MM-dd HH:mm:ss
    case withBlank
    /// 24시간제 시간
    case hourClock24
    /// 12시간제 시간
    case hourClock12
}

extension DateType {
    var dateFormatter: String {
        switch self {
        case .withTime:
            return "yyyy-MM-dd'T'HH:mm:ss"
        case .hyphen:
            return "yyyy-MM-dd"
        case .withT:
            return "yyyy-MM-dd'T'"
        case .withBlank:
            return "yyyy-MM-dd HH:mm:ss"
        case .hourClock24:
            return "HH:mm"
        case .hourClock12:
            return "hh:mm"
        }
    }
}
