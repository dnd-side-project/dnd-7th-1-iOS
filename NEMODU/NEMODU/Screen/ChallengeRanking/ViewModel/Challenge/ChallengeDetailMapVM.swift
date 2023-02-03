//
//  ChallengeDetailMapVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/01/21.
//

import Foundation
import RxCocoa
import RxSwift

final class ChallengeDetailMapVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var challengeDetailMap = PublishRelay<ChallengeDetailMapResponseModel>()
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

extension ChallengeDetailMapVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension ChallengeDetailMapVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension ChallengeDetailMapVM {
    func getChallengeDetailMap(uuid: String) {
        let path = "challenge/detail/map?uuid=\(uuid)"
        let resource = urlResource<ChallengeDetailMapResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.challengeDetailMap.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
