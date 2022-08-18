//
//  ChallengeListVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import RxCocoa
import RxSwift

protocol ChallengeListViewModelOutput: Lodable {
    var onError: PublishSubject<APIError> { get }
    var challengeList: BehaviorRelay<[ChallengeElementResponseModel]> { get }
    var dataSource: Observable<[ProceedingChallengeDataSource]> { get }
}

final class ChallengeListVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: ChallengeListViewModelOutput {
        var onError = PublishSubject<APIError>()
        var loading = BehaviorRelay<Bool>(value: false)
        var challengeList: BehaviorRelay<[ChallengeElementResponseModel]> = BehaviorRelay(value: [])
        var dataSource: Observable<[ProceedingChallengeDataSource]> {
            challengeList
                .map {
                    [ProceedingChallengeDataSource(section: .zero, items: $0)]
                }
        }
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

// MARK: - Helpers

extension ChallengeListVM {}

// MARK: - Input

extension ChallengeListVM: Input {
    func bindInput() { }
}

// MARK: - Output

extension ChallengeListVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension ChallengeListVM {
    func getProceedingChallengeList() {
        let nickname = "NickA"
        let path = "challenge/progress?nickname=\(nickname)"
        let resource = urlResource<[ChallengeElementResponseModel]>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.challengeList.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
