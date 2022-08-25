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
    case nicknameChanged
    case networkError
}

extension ToastType {
    var toastMessage: String {
        switch self {
        case .friendProfileError:
            return "정보를 불러오지 못했습니다. 다시 시도해주세요."
        case .friendAdded:
            return "친구 신청이 완료 되었습니다."
        case .nicknameChanged:
            return "닉네임이 변경 되었습니다."
        case .networkError:
            return "연결이 좋지 않습니다. 네트워크 연결을 확인해주세요."
        }
    }
}
