//
//  AlertType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/25.
//

import Foundation

enum AlertType {
    case requestLocationAuthority
    case requestMotionAuthority
    case recordNetworkError
    case defaultNetworkError
    case minimumBlocks
    case speedWarning
    case realTimeChallenge
    case createWeekChallenge
    case sendMailError
    case profileEdited
}

extension AlertType {
    var alertTitle: String {
        switch self {
        case .requestLocationAuthority:
            return "위치 정보 접근을 허용해주세요!"
        case .requestMotionAuthority:
            return "동작 및 피트니스 활동\n접근을 허용해주세요!"
        case .recordNetworkError:
            return "네트워크 오류로 인해\n기록이 저장되지 않았습니다.\n\n다시 시도해볼까요?"
        case .defaultNetworkError:
            return "네트워크 지연 문제"
        case .minimumBlocks:
            return "5칸 이상 걸어야\n기록이 가능합니다."
        case .speedWarning:
            return "혹시 자동차나 자전거를\n타고 계신가요?"
        case .realTimeChallenge:
            return "준비중"
        case .createWeekChallenge:
            return "주간 챌린지 생성 실패"
        case .sendMailError:
            return "메일(Mail) 앱을 열 수 없습니다"
        case .profileEdited:
            return "프로필 편집 나가기"
        }
    }
    
    var alertMessage: String? {
        switch self {
        case .requestLocationAuthority:
            return "회원님의 위치 정보는\n활동 기록 및 측정에 사용됩니다.\n\n정보는 친구들에게만 보여지며\n설정에서 언제든 공유를 중지할 수 있습니다."
        case .requestMotionAuthority:
            return "회원님의 피트니스 정보는\n걸음수 기록 및 측정에 사용됩니다.\n\n해당 정보는 보다 정확한\n기록 측정을 위해 사용됩니다.\n설정에서 언제든 공유를 중지할 수 있습니다."
        case .recordNetworkError:
            return nil
        case .defaultNetworkError:
            return "네트워크가 원활하지 않아 접속이 지연되고\n있습니다. 잠시 후에 다시 시도해 주세요."
        case .minimumBlocks:
            return "지금 기록을 정지하는 경우\n지금까지 진행한 기록은 삭제됩니다.\n\n정말 기록을 끝내시겠어요?"
        case .speedWarning:
            return "속도가 너무 빠른 경우\n기록이 일시정지됩니다.\n\n네모두는 산책, 달리기 기록만\n측정가능합니다.\n🏃우리 함께 걸어보아요!🏃‍♀️ "
        case .realTimeChallenge:
            return "조금만 기다려주세요🏃‍♀️"
        case .createWeekChallenge:
            return "생성에 오류가 발생하였습니다"
        case .sendMailError:
            return "아래 주소를 통해 문의하실 수 있습니다\n📨 nemodu.official@gmail.com"
        case .profileEdited:
            return "화면을 나가면 변경사항은 저장되지 않습니다. 나가시겠습니까?"
        }
    }
    
    var highlightBtnTitle: String {
        switch self {
        case .requestLocationAuthority, .requestMotionAuthority:
            return "시스템 설정 가기"
        case .recordNetworkError:
            return "다시 저장하기"
        case .defaultNetworkError, .realTimeChallenge, .createWeekChallenge, .sendMailError, .profileEdited:
            return "확인"
        case .minimumBlocks, .speedWarning:
            return "계속 하기"
        }
    }
    
    var normalBtnTitle: String? {
        switch self {
        case .requestMotionAuthority:
            return "다음에"
        case .recordNetworkError:
            return "그냥 나가기"
        case .requestLocationAuthority, .defaultNetworkError, .realTimeChallenge, .createWeekChallenge, .sendMailError:
            return nil
        case .minimumBlocks, .speedWarning:
            return "기록 끝내기"
        case .profileEdited:
            return "취소"
        }
    }
}
