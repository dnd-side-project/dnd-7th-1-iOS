//
//  AddDeleteFriendProtocol.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddDeleteFriendProtocol: AnyObject where Self: BaseViewModel {
    var requestStatus: PublishRelay<Bool> { get }
    var deleteStatus: PublishRelay<Bool> { get }
}

extension AddDeleteFriendProtocol {
    func requestFriend(to friend: FriendRequestModel) {
        let path = "friend/request"
        let resource = urlResource<Bool>(path: path)
        
        apiSession.postRequest(with: resource, param: friend.param)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.requestStatus.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func deleteFriend(to friend: FriendRequestModel) {
        let path = "friend/delete"
        let resource = urlResource<Bool>(path: path)
        
        apiSession.postRequest(with: resource, param: friend.param)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.deleteStatus.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
