//
//  KakaoFriendListResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/23.
//

import Foundation

struct KakaoFriendListResponseModel: Codable {
    let friends: [KakaoFriendInfo]
    let isLast: Bool
    let offset: Int?
}
