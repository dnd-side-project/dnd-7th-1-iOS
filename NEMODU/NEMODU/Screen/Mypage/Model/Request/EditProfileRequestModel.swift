//
//  EditProfileRequestModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/15.
//

import UIKit
import Alamofire

struct EditProfileRequestModel {
    let profileImage: UIImage
    let editNick, intro: String
}

extension EditProfileRequestModel{
    var profileParam: Parameters {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        return [
            "originalNick": nickname,
            "editNick": editNick,
            "intro": intro
        ]
    }
}
