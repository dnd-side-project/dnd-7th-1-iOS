//
//  ToastType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/25.
//

import Foundation

enum ToastType {
    case informationError
    case networkError
    case postFriendRequest
    case cancelFriendRequest
    case acceptFriendRequest(nickname: String)
    case refuseFriendRequest(nickname: String)
    case profileChanged
    case saveCompleted
    case noRecord
}

extension ToastType {
    var toastMessage: String {
        switch self {
        case .informationError:
            return "정보를 불러오지 못했습니다. 다시 시도해주세요."
        case .postFriendRequest:
            return "친구 요청을 보냈습니다."
        case .cancelFriendRequest:
            return "친구 요청이 취소되었습니다."
        case .acceptFriendRequest(let nickname):
            return "\(nickname)님과 친구가 되었습니다."
        case .refuseFriendRequest(let nickname):
            return "\(nickname)님의 친구 요청을 거절하였습니다."
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
