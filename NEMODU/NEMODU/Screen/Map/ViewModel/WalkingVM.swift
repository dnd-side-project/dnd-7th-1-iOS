//
//  WalkingVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/09.
//

import Foundation
import RxCocoa
import RxSwift

protocol WalkingViewModelOutput: Lodable {
    var blocksCnt: PublishRelay<Int> { get }
    var myBlocksVisible: BehaviorRelay<Bool> { get }
    var friendVisible: BehaviorRelay<Bool> { get }
    var myBlocks: PublishRelay<UserBlockResponseModel> { get }
    var friendBlocks: PublishRelay<[UserBlockResponseModel]> { get }
    var challengeFriendBlocks: PublishRelay<[ChallengeBlockResponseModel]> { get }
}

final class WalkingVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: WalkingViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        
        let driver = Driver<Int>
            .interval(.seconds(1))
            .map { _ in
                return 1
            }
        var myBlocksVisible = BehaviorRelay<Bool>(value: false)
        var friendVisible = BehaviorRelay<Bool>(value: false)
        var blocksCnt = PublishRelay<Int>()
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

extension WalkingVM {}

// MARK: - Input

extension WalkingVM: Input {
    func bindInput() { }
}

// MARK: - Output

extension WalkingVM: Output {
    func bindOutput() { }
}

// MARK: - Networking

extension WalkingVM {
    func getAllBlocks(_ latitude: Double, _ longitude: Double, _ spanDelta: Double) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "user/home?nickname=\(nickname)&latitude=\(latitude)&longitude=\(longitude)&spanDelta=\(spanDelta)"
        let resource = urlResource<MainMapResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.myBlocksVisible.accept(data.isShowMine)
                    owner.output.friendVisible.accept(data.isShowFriend)
                    if let userMatrices = data.userMatrices {
                        owner.output.myBlocks.accept(userMatrices)
                    }
                    if let friendMatrices = data.friendMatrices {
                        owner.output.friendBlocks.accept(friendMatrices)
                    }
                    if let challengeMatrices = data.challengeMatrices {
                        owner.output.challengeFriendBlocks.accept(challengeMatrices)
                    }
                }
            })
            .disposed(by: bag)
    }
}
