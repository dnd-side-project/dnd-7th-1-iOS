//
//  SearchFriendProtocol.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/25.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchFriendProtocol: AnyObject where Self: BaseViewModel {
    var searchList: PublishRelay<[FriendDefaultInfo]> { get }
}

extension SearchFriendProtocol {
    func getSearchResult(_ keyword: String) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "friend/search?nickname=\(nickname)&keyword=\(keyword)"
        let resource = urlResource<[FriendDefaultInfo]>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.searchList.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
