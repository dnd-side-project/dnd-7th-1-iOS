//
//  InvitedChallengeDetailVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/01.
//

import Foundation
import RxCocoa
import RxSwift

final class InvitedChallengeDetailVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var isAcceptChallengeSuccess = PublishRelay<Bool>()
        var isRejectChallengeSuccess = PublishRelay<Bool>()
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

extension InvitedChallengeDetailVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension InvitedChallengeDetailVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension InvitedChallengeDetailVM {
    func requestAcceptChallenge(with param: AcceptRejectChallengeRequestModel) {
        let path = "challenge/accept"
        let resource = urlResource<AcceptRejectChallengeRequestModel>(path: path)
        
        apiSession.postRequest(with: resource, param: param.acceptRejectChallenge)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    owner.output.isAcceptChallengeSuccess.accept(false)
                case .success(_):
                    owner.output.isAcceptChallengeSuccess.accept(true)
                }
            })
            .disposed(by: bag)
    }
    
    func requestRejectChallenge(with param: AcceptRejectChallengeRequestModel) {
        let path = "challenge/reject"
        let resource = urlResource<AcceptRejectChallengeRequestModel>(path: path)
        
        apiSession.postRequest(with: resource, param: param.acceptRejectChallenge)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    owner.output.isRejectChallengeSuccess.accept(false)
                case .success(_):
                    owner.output.isRejectChallengeSuccess.accept(true)
                }
            })
            .disposed(by: bag)
    }
}
