//
//  AreaRankingListVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/19.
//

import Foundation
import RxCocoa
import RxSwift

protocol AreaRankingListViewModelOuput: Lodable {
    var areaRankings: PublishRelay<AreaRankingListResponseModel> { get }
}

final class AreaRankingListVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: AreaRankingListViewModelOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        var areaRankings = PublishRelay<AreaRankingListResponseModel>()
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

extension AreaRankingListVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension AreaRankingListVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension AreaRankingListVM {
    func getAreaRankingList(with param: RankingListRequestModel) {
        let path = "matrix/rank/widen"
        let resource = urlResource<AreaRankingListResponseModel>(path: path)
        
        apiSession.postRequest(with: resource, param: param.rankingParam)
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
}
