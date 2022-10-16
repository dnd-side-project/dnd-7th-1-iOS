//
//  EditMemoRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/11.
//

import Foundation
import Alamofire

struct EditMemoRequestModel {
    var message: String
    var recordId: Int
}

extension EditMemoRequestModel {
    var memoParam: Parameters {
        return [
            "message": message,
            "recordId": recordId
        ]
    }
}
