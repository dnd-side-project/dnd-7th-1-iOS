//
//  FriendsListResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/01.
//

import Foundation
import Alamofire

struct FriendsListResponseModel: Codable {
    let infos: [String]
    let isLast: Bool
    let size: Int
}
