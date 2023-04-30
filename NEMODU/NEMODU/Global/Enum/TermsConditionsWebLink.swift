//
//  TermsConditionsWebLink.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/25.
//

import UIKit

enum TermsConditionsWebLink: String {
    case service
    case privacy
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
