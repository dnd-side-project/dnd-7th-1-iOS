//
//  APIError.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import Foundation

enum APIError: Error {
    /// 서비스 종료(서버 죽음)
    case endOfOperation(_ status: Int)
    /// 정의되지 않은 에러
    case unknownError(_ status: Int)
    /// 서버에서 내려주는 모든 에러
    case error(_ errorModel: ErrorResponseModel)
}

extension APIError {
    var title: String {
        switch self {
        case .endOfOperation:
            return "서비스 운영이 종료되었습니다."
        case .unknownError:
            return "NEMODU 서버에 연결할 수 없습니다."
        case .error(let error):
            return error.message ?? "서비스에 오류가 발생했습니다 😢"
        }
    }
    
    var code: String {
        switch self {
        case .endOfOperation(let status):
            return "\(status)"
        case .unknownError(let status):
            return "\(status)"
        case .error(let error):
            return error.code ?? "unknown error"
        }
    }
    
    // MARK: - 테스트플라이트 에러 확인용 임시
    var message: String {
        switch self {
        case .endOfOperation(let status):
            return "(\(status)) 찬호야 서버 켜줘.."
        case .unknownError(let status):
            return "Error Code: \(status)"
        case .error:
            return "Error Code: \(self.code)"
        }
    }
}
