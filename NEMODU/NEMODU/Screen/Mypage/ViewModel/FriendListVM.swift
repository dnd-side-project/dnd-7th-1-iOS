//
//  FriendListVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/14.
//

import Foundation
import RxCocoa
import RxSwift

final class FriendListVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var friendRequestList = FriendRequestList()
        var myFriendsList = MyFriends()
    }
    
    // 친구 요청 목록
    struct FriendRequestList {
        var dataSource: Observable<[FriendListDataSource]> {
            friendsInfo.map { [FriendListDataSource(section: .zero, items: $0)]}
        }
        var friendsInfo = PublishRelay<[FriendsInfo]>()
    }
    
    // 친구 목록
    struct MyFriends: FriendListOutput {
        var dataSource: Observable<[FriendListDataSource]> {
            friendsInfo.map { [FriendListDataSource(section: .zero, items: $0)] }
        }
        var friendsInfo = PublishRelay<[FriendsInfo]>()
        var size = BehaviorRelay<Int>(value: 0)
        var isLast = BehaviorRelay<Bool>(value: true)
        var nextOffset = PublishRelay<Int>()
    }
}

// MARK: - Input

extension FriendListVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension FriendListVM: Output {
    func bindOutput() {}
}
