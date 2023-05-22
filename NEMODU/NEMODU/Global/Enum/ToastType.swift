//
//  ToastType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/25.
//

import Foundation

enum ToastType {
    case friendProfileError
    case friendAdded
    case friendDeleted
    case profileChanged
    case networkError
    case saveCompleted
    case noRecord
}

extension ToastType {
    var toastMessage: String {
        switch self {
        case .friendProfileError:
            return "정보를 불러오지 못했습니다. 다시 시도해주세요."
        case .friendAdded:
            return "친구 요청을 보냈습니다."
        case .friendDeleted:
            return "친구 요청이 취소되었습니다."
        case .profileChanged:
            return "프로필이 변경 되었습니다."
        case .networkError:
            return "연결이 좋지 않습니다. 네트워크 연결을 확인해주세요."
        case .saveCompleted:
            return "저장이 완료되었습니다."
        case .noRecord:
            return "기록이 없습니다."
        }
    }
}
