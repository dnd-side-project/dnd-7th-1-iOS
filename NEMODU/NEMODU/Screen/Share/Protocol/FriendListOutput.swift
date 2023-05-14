//
//  FriendListOutput.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/14.
//

import RxCocoa
import RxSwift

protocol FriendListOutput {
    var dataSource: Observable<[FriendListDataSource]> { get }
    var friendsInfo: PublishRelay<[FriendsInfo]> { get }
    var size: BehaviorRelay<Int> { get } // 이전 페이지의 친구 개수 (몇명인지)
    var isLast: BehaviorRelay<Bool> { get }   // 마지막 페이지인지 bool값
    var nextOffset: PublishRelay<Int> { get }    // 다음 친구 목록 요청에 필요한 offset
}
