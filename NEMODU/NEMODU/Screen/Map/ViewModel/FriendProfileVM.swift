//
//  FriendProfileVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import Foundation
import RxCocoa
import RxSwift

protocol FriendProfileViewModelOutput: Lodable {
    var profileData: PublishRelay<ProfileResponseModel> { get }
    var challengeList: BehaviorRelay<[ChallengeElementResponseModel]> { get }
    var dataSource: Observable<[ProceedingChallengeDataSource]> { get }
}

final class FriendProfileVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: FriendProfileViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        var profileData = PublishRelay<ProfileResponseModel>()
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

// MARK: - Input

extension FriendProfileVM: Input {
    func bindInput() { }
}

// MARK: - Output

extension FriendProfileVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension FriendProfileVM {
    func getFriendProfile(friendNickname: String) {
        // TODO: - UserDefaults 수정
        let nickname = "NickA"
        let path = "user/profile?friend=\(friendNickname)&user=\(nickname)"
        let resource = urlResource<ProfileResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.profileData.accept(data)
                    owner.output.challengeList.accept(data.challenges)
                }
            })
            .disposed(by: bag)
    }
}
