//
//  MainVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/17.
//

import RxCocoa
import RxSwift

protocol MainViewModelOutput: Lodable {
    var onError: PublishSubject<APIError> { get }
    var challengeCnt: PublishRelay<Int> { get }
    var myBlocks: PublishRelay<UserBlockResponseModel> { get }
    var friendBlocks: PublishRelay<[UserBlockResponseModel]> { get }
    var challengeFriendBlocks: PublishRelay<[ChallengeBlockResponseModel]> { get }
}

final class MainVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: MainViewModelOutput {
        var onError = PublishSubject<APIError>()
        var loading = BehaviorRelay<Bool>(value: false)
        var challengeCnt = PublishRelay<Int>()
        var myBlocks = PublishRelay<UserBlockResponseModel>()
        var friendBlocks = PublishRelay<[UserBlockResponseModel]>()
        var challengeFriendBlocks = PublishRelay<[ChallengeBlockResponseModel]>()
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

extension MainVM {}

// MARK: - Input

extension MainVM: Input {
    func bindInput() { }
}

// MARK: - Output

extension MainVM: Output {
    func bindOutput() { }
}

// MARK: - Networking

extension MainVM {
    func getAllBlocks() {
        // TODO: - UserDefaults 수정
        let nickname = "NickA"
        let path = "user/home?nickname=\(nickname)"
        let resource = urlResource<MainMapResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.challengeCnt.accept(data.challengesNumber)
                    owner.output.myBlocks.accept(data.userMatrices)
                    owner.output.friendBlocks.accept(data.friendMatrices)
                    owner.output.challengeFriendBlocks.accept(data.challengeMatrices)
                }
            })
            .disposed(by: bag)
    }
}
