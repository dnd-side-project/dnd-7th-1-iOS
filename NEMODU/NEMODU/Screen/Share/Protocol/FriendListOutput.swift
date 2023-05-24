//
//  FriendListOutput.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/14.
//

import RxCocoa
import RxSwift

protocol FriendListOutput {
    associatedtype T
    var dataSource: Observable<[FriendListDataSource<T>]> { get }
    var friendsInfo: BehaviorRelay<[T]> { get }
    /// 마지막 페이지인지 bool 값
    var isLast: BehaviorRelay<Bool> { get }
    /// 다음 친구 목록 요청에 필요한 값. 초기값 반드시 null. not 0
    var nextOffset: BehaviorRelay<Int?> { get }
}
