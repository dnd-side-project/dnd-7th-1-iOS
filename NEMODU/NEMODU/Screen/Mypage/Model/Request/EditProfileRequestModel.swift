//
//  EditProfileRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/15.
//

import UIKit
import Alamofire

struct EditProfileRequestModel {
    let picture: UIImage
    let editNickname: String
    let intro: String
    let isBasic: Bool
}

extension EditProfileRequestModel{
    var profileParam: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "originNickname": nickname,
            "editNickname": editNickname,
            "intro": intro,
            "isBasic": isBasic
        ]
    }
}
