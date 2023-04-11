//
//  ChallengeType.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/12/03.
//

import UIKit

enum ChallengeType: String {
    case widen = "WIDEN"
    case accumulate = "ACCUMULATE"
}

extension ChallengeType {
    var title: String {
        switch self {
        case .widen:
            return "영역 넓히기"
        case .accumulate:
            return "칸 누적하기"
        }
    }
}
