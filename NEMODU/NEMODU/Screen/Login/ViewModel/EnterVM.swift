//
//  EnterVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/14.
//

import Foundation
import RxCocoa
import RxSwift

final class EnterVM: BaseViewModel {
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
        var isLoginSuccess = PublishRelay<Bool>()
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

extension EnterVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension EnterVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension EnterVM {
    func requestSignup(_ userData: UserDataModel) {
        let path = "auth/sign"
        let resource = urlResource<NicknameModel>(path: path)
        
        output.beginLoading()
        AuthAPI.shared.signupRequest(with: resource, param: userData.userDataParam)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    UserDefaults.standard.set(data.nickname, forKey: UserDefaults.Keys.nickname)
                    owner.output.isLoginSuccess.accept(true)
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
}
