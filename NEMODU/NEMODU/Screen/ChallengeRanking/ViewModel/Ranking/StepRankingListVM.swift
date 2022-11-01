//
//  StepRankingListVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/19.
//

import Foundation
import RxCocoa
import RxSwift

protocol StepRankingListViewModelOuput: Lodable {
    var stepRankings: PublishRelay<StepRankingListResponseModel> { get }
}

final class StepRankingListVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: StepRankingListViewModelOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        var stepRankings = PublishRelay<StepRankingListResponseModel>()
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

extension StepRankingListVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension StepRankingListVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension StepRankingListVM {
    func getStepRankingList(with param: RankingListRequestModel) {
        let path = "record/rank/step"
        let resource = urlResource<StepRankingListResponseModel>(path: path)
        
        apiSession.postRequest(with: resource, param: param.rankingParam)
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
}
