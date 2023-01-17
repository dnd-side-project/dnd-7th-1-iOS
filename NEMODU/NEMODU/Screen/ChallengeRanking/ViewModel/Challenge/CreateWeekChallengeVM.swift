//
//  CreateWeekChallengeVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/20.
//

import Foundation
import RxCocoa
import RxSwift

final class CreateWeekChallengeVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var isCreateWeekChallengeSuccess = PublishRelay<Bool>()
        var successWithResponseData = PublishRelay<CreatChallengeResponseModel>()
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

extension CreateWeekChallengeVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension CreateWeekChallengeVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension CreateWeekChallengeVM {
    func requestCreateWeekChallengeVM(with param: CreateChallengeRequestModel) {
        let path = "challenge/"
        let resource = urlResource<CreatChallengeResponseModel>(path: path)
        
        apiSession.postRequest(with: resource, param: param.createChallenge)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                    owner.output.isCreateWeekChallengeSuccess.accept(false)
                case .success(let data):
                    owner.output.successWithResponseData.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
