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
        
        // Rank
        var usersRankData = BehaviorRelay<[RankingList]>(value: [])
        
        // Matrices
        var userMatrixData = PublishRelay<[MatrixList]>()
        var matrices = PublishRelay<(nickname: String, matrices: [Matrix])>()
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
    func getChallengeDetailMap(uuid: String, latitude: Double, longitude: Double) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "challenge/detail/map?nickname=\(nickname)&uuid=\(uuid)&latitude=\(latitude)&longitude=\(longitude)&spanDelta=\(Map.defaultZoomScale * 1.5)"
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
    
    /// 지도 제스쳐 시, 현재 화면에 보이는 영역을 받아오는 메서드
    func getUpdateBlocks(_ uuid: String, _ latitude: Double, _ longitude: Double, _ spanDelta: Double = Map.defaultZoomScale * 1.5) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let type = MapType.challenge.rawValue
        let path = "matrix?nickname=\(nickname)&latitude=\(latitude)&longitude=\(longitude)&spanDelta=\(spanDelta)&type=\(type)&uuid=\(uuid)"
        let resource = urlResource<[UserMatrixResponseModel]?>(path: path)
        
        output.beginLoading()
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    guard let data = data else { return }
                    for data in data {
                        owner.output.matrices.accept((data.nickname, data.matrices))
                    }
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
}
