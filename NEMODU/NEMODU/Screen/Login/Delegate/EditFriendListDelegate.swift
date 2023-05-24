//
//  EditFriendListDelegate.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/24.
//

import Foundation

protocol EditFriendListDelegate: AnyObject {
    func addFriend(_ nickname: String)
    
    func removeFriend(_ nickname: String)
}
