//
//  APIError.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import Foundation

enum APIError: Error {
    case badGateway
    case error(_ errorModel: ErrorResponseModel)
}

extension APIError {
    var title: String? {
        switch self {
        case .badGateway:
            return "NEMODU 서버에 연결할 수 없습니다."
        case .error(let error):
            return error.message
        }
    }
    
    var code: String? {
        switch self {
        case .badGateway:
            return nil
        case .error(let error):
            return error.code
        }
    }
}
