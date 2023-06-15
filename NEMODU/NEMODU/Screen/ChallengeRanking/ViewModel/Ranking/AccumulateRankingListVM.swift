//
//  AccumulateRankingListVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/19.
//

import Foundation
import RxCocoa
import RxSwift

protocol AccumulateRankingListViewModelOuput: Lodable {
    var accumulateRankings: PublishRelay<AccumulateRankingListResponseModel> { get }
}

final class AccumulateRankingListVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: AccumulateRankingListViewModelOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        
        var myAccumulateRanking = PublishRelay<MatrixRanking>()
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

extension AccumulateRankingListVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension AccumulateRankingListVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension AccumulateRankingListVM {
    func getMyAccumulateRanking(nickname: String) {
        let path = "matrix/rank/accumulate/\(nickname)"
        let resource = urlResource<MatrixRanking>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.myAccumulateRanking.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func getAccumulateRankingList(offset: Int, size: Int = 10) {
        let path = "matrix/rank/accumulate?offset=\(offset)&size=\(size)"
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
