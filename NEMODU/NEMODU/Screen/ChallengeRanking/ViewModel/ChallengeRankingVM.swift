//
//  ChallengeRankingVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/22.
//

import Foundation
import RxCocoa
import RxSwift

// VC마다 하나씩 대응(ChallengeRankingVC)
protocol ChallengeRankingViewModelOutput: Lodable {
    var areaRankings: PublishRelay<AreaRankingListResponseModel> { get }
}

final class ChallengeRankingVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: ChallengeRankingViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        
        var areaRankings = PublishRelay<AreaRankingListResponseModel>()
        var stepRankings = PublishRelay<StepRankingListResponseModel>()
        var accumulateRankings = PublishRelay<AccumulateRankingListResponseModel>()
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

extension ChallengeRankingVM: Input {
    func bindInput() { }
}

// MARK: - Output

extension ChallengeRankingVM: Output {
    func bindOutput() { }
}

// MARK: - Networking

extension ChallengeRankingVM {
    func getAreaRankingList(with param: RankingListRequestModel) {
        let path = "matrix/rank/widen"
        let resource = urlResource<AreaRankingListResponseModel>(path: path)
        
        apiSession.postRequest(with: resource, param: param.areaParam)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.areaRankings.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func getStepRankingList(with param: RankingListRequestModel) {
        let path = "record/rank/step"
        let resource = urlResource<StepRankingListResponseModel>(path: path)
        
        apiSession.postRequest(with: resource, param: param.areaParam)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.stepRankings.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func getAccumulateRankingList(with nickname: String) {
        let path = "/matrix/rank/accumulate?nickname=\(nickname)"
        let resource = urlResource<AccumulateRankingListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.accumulateRankings.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
