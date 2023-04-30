//
//  TermsConditionsWebLink.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/25.
//

import UIKit

enum TermsConditionsWebLink: String {
    // 서비스 이용약관
    case service
    // 개인 정보 수집 및 이용 동의
    case privacy
    // 위치 기반 서비스 약관 동의
    case location
}

extension TermsConditionsWebLink {
    var baseURL: String {
        return "https://nemodu-s3.s3.ap-northeast-2.amazonaws.com/terms/"
    }
    
    var url: String {
        switch self {
        case .service:
            return baseURL + "terms_service.html"
        case .privacy:
            return baseURL + "terms_personal_information_collection.html"
        case .location:
            return baseURL + "terms_location_service.html"
        }
    }
}
