//
//  LoginRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/01/31.
//

import Foundation
import Alamofire

struct LoginRequestModel {
    let email: String
    let loginType: String
}

extension LoginRequestModel {
    var param: Parameters {
        return [
            "email": email,
            "loginType": loginType
        ]
    }
}
