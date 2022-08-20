//
//  NoChallengeStatusMessage.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/20.
//

import UIKit

enum NoChallengeStatusMessageType: Int {
    case waiting = 0
    case doing = 1
    case finish = 2
    case noChallengeData = 3
}

extension NoChallengeStatusMessageType {
    var message: String {
        switch self {
        case .waiting:
            return "진행 대기중인 챌린지가 없습니다."
        case .doing:
            return "진행 중인 챌린지가 없습니다."
        case .finish:
            return  "진행완료 된 챌린지가 없습니다."
        case .noChallengeData:
            return  "챌린지 정보를 불러올 수 없습니다."
        }
    }
}
