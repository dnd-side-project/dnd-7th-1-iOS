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
        var requestHandlingStatus = PublishRelay<FriendRequestHandlingModel>()
    }
    
    // 친구 요청 목록
    struct FriendRequestList: FriendListOutput {
        var dataSource: Observable<[FriendListDataSource<FriendDefaultInfo>]> {
            friendsInfo.map { [FriendListDataSource(section: .zero, items: $0)]}
        }
        var friendsInfo = BehaviorRelay<[FriendDefaultInfo]>(value: [])
        var isLast = BehaviorRelay<Bool>(value: true)
        var nextOffset = BehaviorRelay<Int?>(value: nil)
    }
    
    // 친구 목록
    struct MyFriends: FriendListOutput {
        var dataSource: Observable<[FriendListDataSource<FriendDefaultInfo>]> {
            friendsInfo.map { [FriendListDataSource(section: .zero, items: $0)] }
        }
        var friendsInfo = BehaviorRelay<[FriendDefaultInfo]>(value: [])
        var isLast = BehaviorRelay<Bool>(value: true)
        var nextOffset = BehaviorRelay<Int?>(value: nil)
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

// MARK: - Network

extension FriendListVM {
    /// 친구 요청 목록 조회 메서드
    func getFriendRequestList(size: Int) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        var path = "friend/receive?nickname=\(nickname)&size=\(size)"
        if let offset = output.friendRequestList.nextOffset.value {
            path += "&offset=\(offset)"
        }
        let resource = urlResource<FriendsListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.friendRequestList.friendsInfo.accept(data.infos)
                }
            })
            .disposed(by: bag)
    }
    
    /// 친구 요청을 거절/수락하는 메서드
    func postRequestHandling(_ requestHandlingRequestModel: FriendRequestHandlingModel) {
        let path = "friend/response"
        let resource = urlResource<FriendRequestHandlingModel>(path: path)
        
        apiSession.postRequest(with: resource, param: requestHandlingRequestModel.param)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.requestHandlingStatus.accept(data)
                }
            })
            .disposed(by: bag)
    }
}

