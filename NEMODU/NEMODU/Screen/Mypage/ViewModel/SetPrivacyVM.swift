//
//  SetPrivacyVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/05/22.
//

import Foundation

import RxCocoa
import RxSwift

protocol SetPrivacyVMOuput: Lodable {
    var userPrivacySetting: PublishRelay<SetPrivacyResponseModel> { get }
}

final class SetPrivacyVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: SetPrivacyVMOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        var userPrivacySetting = PublishRelay<SetPrivacyResponseModel>()
        var isSuccessUpdatePrivacySetting = PublishRelay<Bool>()
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

extension SetPrivacyVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension SetPrivacyVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension SetPrivacyVM {
    func getUserPrivacySetting() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "user/filter/recommend?nickname=\(nickname)"
        let resource = urlResource<SetPrivacyResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.userPrivacySetting.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func updateUserPrivacySetting() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }

        let path = "user/filter/recommend/friend?nickname=\(nickname)"
        let resource = urlResource<Bool>(path: path)

        apiSession.postRequest(with: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                    owner.output.isSuccessUpdatePrivacySetting.accept(false)
                case .success(let data):
                    owner.output.isSuccessUpdatePrivacySetting.accept(data)
                }
            })
            .disposed(by: bag)
    }
}

