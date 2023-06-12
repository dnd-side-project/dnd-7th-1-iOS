//
//  SelectFriendsVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/01.
//

import Foundation
import RxCocoa
import RxSwift

final class SelectFriendsVM: BaseViewModel, SearchFriendProtocol {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - SearchFriendProtocol
    
    var searchList = PublishRelay<[FriendDefaultInfo]>()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var friendsList = BehaviorRelay<[FriendDefaultInfo]>(value: [])
        var isLast = BehaviorRelay<Bool>(value: true)
        var nextOffset = BehaviorRelay<Int?>(value: nil)
    }
    
    // MARK: - Init
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Input

extension SelectFriendsVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension SelectFriendsVM: Output {
    func bindOutput() {
        searchList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.output.friendsList.accept(data)
            })
            .disposed(by: bag)
    }
}

// MARK: - Networking

extension SelectFriendsVM {
    func getFriendList(size: Int) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        var path = "friend/list?nickname=\(nickname)&size=\(size)"
        if let offset = output.nextOffset.value {
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
                    owner.output.friendsList.accept(data.infos)
                    owner.output.nextOffset.accept(data.offset)
                    owner.output.isLast.accept(data.isLast)
                }
            })
            .disposed(by: bag)
    }
}
