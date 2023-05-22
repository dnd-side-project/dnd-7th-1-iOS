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
    
    struct Input {
        /// 유저에 해당하는 영역 색을 저장하는 딕셔너리
        var userTable = [String: MatrixList]()
    }
    
    // MARK: - Output
    
    struct Output: Lodable {
        var loading = BehaviorRelay<Bool>(value: false)
        var userMatrixData = PublishRelay<[MatrixList]>()
        var usersRankData = BehaviorRelay<[RankingList]>(value: [])
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
    func getChallengeDetailMap(nickname: String, uuid: String) {
        let path = "challenge/detail/map?nickname=\(nickname)&uuid=\(uuid)"
        let resource = urlResource<ChallengeDetailMapResponseModel>(path: path)
        
        output.beginLoading()
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    // userTable 생성
                    for i in 0..<data.matrixList.count {
                        owner.input.userTable[data.matrixList[i].nickname] = data.matrixList[i]
                    }
                    // data binding
                    owner.output.userMatrixData.accept(data.matrixList)
                    owner.output.usersRankData.accept(data.rankingList)
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
}
