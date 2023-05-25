//
//  NEMODUFriendListResponseModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/24.
//

import Foundation

struct NEMODUFriendListResponseModel: Codable {
    let infos: [FriendDefaultInfo]
    let isLast: Bool
    let offset: Double
    let size: Int
}
