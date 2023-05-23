//
//  MyDetailMapVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/23.
//

import Foundation
import RxCocoa
import RxSwift

final class MyDetailMapVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: Lodable {
        var loading = BehaviorRelay<Bool>(value: false)
        var profileImageURL = PublishRelay<URL?>()
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

extension MyDetailMapVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension MyDetailMapVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension MyDetailMapVM {
    func getMypageData() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "user/info/profile/picture?nickname=\(nickname)"
        let resource = urlResource<MyProfileImageResponseModel>(path: path)
        
        output.beginLoading()
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.profileImageURL.accept(data.picturePathURL)
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
}
