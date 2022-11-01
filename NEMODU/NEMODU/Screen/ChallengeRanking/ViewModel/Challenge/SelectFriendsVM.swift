//
//  SelectFriendsVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/01.
//

import Foundation
import RxCocoa
import RxSwift

final class SelectFriendsVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var successWithResponseData = PublishRelay<FriendsListResponseModel>()
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
    func bindOutput() {}
}

// MARK: - Networking

extension SelectFriendsVM {
    func getFriendsList(offset: Int) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "friend/list?nickname=\(nickname)&offset=\(offset)"
        let resource = urlResource<FriendsListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.successWithResponseData.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
