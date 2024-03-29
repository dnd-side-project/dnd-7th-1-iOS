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
    case discardChanges
    case deleteFriend(nickname: String)
    case logout
    case deleteUser
    case searchLimit
    case emptyNotification
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
        case .discardChanges:
            return "지금 나가시겠습니까?\n변경사항이 저장되지 않습니다."
        case .deleteFriend(nickname: let nickname):
            return "‘\(nickname)’님을 친구 목록에서\n 정말 삭제하시겠습니까?"
        case .logout:
            return "로그아웃"
        case .deleteUser:
            return "네모두 탈퇴하기"
        case .searchLimit:
            return "두 글자 이상 입력해주세요."
        case .emptyNotification:
            return "알림함 비우기"
        }
    }
    
    var alertMessage: String? {
        switch self {
        case .requestLocationAuthority:
            return "회원님의 위치 정보는\n활동 기록 및 측정에 사용됩니다.\n\n정보는 친구들에게만 보여지며\n설정에서 언제든 공유를 중지할 수 있습니다."
        case .requestMotionAuthority:
            return "회원님의 피트니스 정보는\n걸음수 기록 및 측정에 사용됩니다.\n\n해당 정보는 보다 정확한\n기록 측정을 위해 사용됩니다.\n설정에서 언제든 공유를 중지할 수 있습니다."
        case .recordNetworkError, .discardChanges, .deleteFriend, .searchLimit:
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
        case .logout:
            return "로그아웃 하시겠습니까?"
        case .deleteUser:
            return "탈퇴하기 버튼을 누르면 모든 정보가 즉시\n삭제되며, 복구할 수 없습니다.\n\n정말로 탈퇴하시겠습니까?"
        case .emptyNotification:
            return "알림함을 정말 비우시겠습니까?"
        }
    }
    
    var highlightBtnTitle: String {
        switch self {
        case .requestLocationAuthority, .requestMotionAuthority:
            return "시스템 설정 가기"
        case .recordNetworkError:
            return "다시 저장하기"
        case .defaultNetworkError, .realTimeChallenge, .createWeekChallenge, .sendMailError, .searchLimit:
            return "확인"
        case .minimumBlocks, .speedWarning:
            return "계속 하기"
        case .discardChanges:
            return "나가기"
        case .deleteFriend:
            return "삭제"
        case .logout:
            return "로그아웃 하기"
        case .deleteUser:
            return "탈퇴하기"
        case .emptyNotification:
            return "비우기"
        }
    }
    
    var normalBtnTitle: String? {
        switch self {
        case .requestMotionAuthority:
            return "다음에"
        case .recordNetworkError:
            return "그냥 나가기"
        case .requestLocationAuthority, .defaultNetworkError, .realTimeChallenge, .createWeekChallenge, .sendMailError, .searchLimit:
            return nil
        case .minimumBlocks, .speedWarning:
            return "기록 끝내기"
        case .discardChanges:
            return "계속 작성하기"
        case .deleteFriend, .logout, .deleteUser, .emptyNotification:
            return "취소"
        }
    }
}
