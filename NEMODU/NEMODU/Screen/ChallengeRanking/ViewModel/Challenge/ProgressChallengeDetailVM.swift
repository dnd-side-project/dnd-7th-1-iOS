//
//  ProgressChallengeDetailVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/12/02.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProgressChallengeDetailVMOuput: Lodable {
    var progressChallengeDetail: PublishRelay<ProgressChallengeDetailResponseModel> { get }
}

final class ProgressChallengeDetailVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: ProgressChallengeDetailVMOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        var progressChallengeDetail = PublishRelay<ProgressChallengeDetailResponseModel>()
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

extension ProgressChallengeDetailVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension ProgressChallengeDetailVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension ProgressChallengeDetailVM {
    func getProgressChallengeDetail(nickname: String, uuid: String) {
        let path = "challenge/detail?nickname=\(nickname)&uuid=\(uuid)"
        let resource = urlResource<ProgressChallengeDetailResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.progressChallengeDetail.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
