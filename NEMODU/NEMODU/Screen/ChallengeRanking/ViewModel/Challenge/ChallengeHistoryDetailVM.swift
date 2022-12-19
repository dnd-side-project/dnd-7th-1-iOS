//
//  ChallengeHistoryDetailVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/12/02.
//

import Foundation
import RxCocoa
import RxSwift

protocol ChallengeHistoryDetailVMOuput: Lodable {
    var challengeHistoryDetail: PublishRelay<ChallengeHistoryDetailResponseModel> { get }
}

final class ChallengeHistoryDetailVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: ChallengeHistoryDetailVMOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        var challengeHistoryDetail = PublishRelay<ChallengeHistoryDetailResponseModel>()
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

extension ChallengeHistoryDetailVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension ChallengeHistoryDetailVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension ChallengeHistoryDetailVM {
    func getChallengeHistoryDetail(nickname: String, uuid: String) {
        let path = "challenge/detail?nickname=\(nickname)&uuid=\(uuid)"
        let resource = urlResource<ChallengeHistoryDetailResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.challengeHistoryDetail.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
