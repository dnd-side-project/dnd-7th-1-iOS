//
//  ChallengeVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/30.
//

import Foundation
import RxCocoa
import RxSwift

protocol ChallengeViewModelOuput: Lodable { }

final class ChallengeVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: ChallengeViewModelOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        
        var invitedChallengeList = PublishRelay<[InvitedChallengeListElement]>()
        var isLastInvitedChallenge = BehaviorRelay<Bool>(value: false)
        var nextOffsetInvitedChallenge = BehaviorRelay<Int?>(value: nil)
        
        var waitChallengeList = PublishRelay<WaitChallengeListResponseModel>()
        
        var progressChallengeList = PublishRelay<ProgressChallengeListResponseModel>()
        
        var doneChallengeList = PublishRelay<[ProgressAndDoneChallengeListElement]>()
        var isLastDoneChallenge = BehaviorRelay<Bool>(value: false)
        var nextOffsetDoneChallenge = BehaviorRelay<Int?>(value: nil)
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

extension ChallengeVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension ChallengeVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension ChallengeVM {
    func refreshInvitedChallengeList() {
        output.isLastInvitedChallenge.accept(false)
        getInvitedChallengeList()
    }
    
    func getInvitedChallengeList(size: Int = 10) {
        if !output.isLastInvitedChallenge.value {
            print("호출됨")
            guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
            var path = "challenge/invite?nickname=\(nickname)&size=\(size)"
            if let offset = output.nextOffsetInvitedChallenge.value {
                path += "&offset=\(offset)"
            }
            let resource = urlResource<InvitedChallengeListResponseModel>(path: path)
            
            apiSession.getRequest(with: resource)
                .withUnretained(self)
                .subscribe(onNext: { owner, result in
                    switch result {
                    case .failure(let error):
                        owner.apiError.onNext(error)
                    case .success(let data):
                        owner.output.invitedChallengeList.accept(data.infos)
                        owner.output.isLastInvitedChallenge.accept(data.isLast)
                        owner.output.nextOffsetInvitedChallenge.accept(data.offset)
                    }
                })
                .disposed(by: bag)
        }
    }
    
    func getWaitChallengeList() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "challenge/wait?nickname=\(nickname)"
        let resource = urlResource<WaitChallengeListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.waitChallengeList.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func getProgressChallengeList() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "challenge/progress?nickname=\(nickname)"
        let resource = urlResource<ProgressChallengeListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.progressChallengeList.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func getDoneChallengeList(size: Int = 10) {
        if !output.isLastDoneChallenge.value {
            guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
            var path = "challenge/done?nickname=\(nickname)&size=\(size)"
            if let offset = output.nextOffsetDoneChallenge.value {
                path += "&offset=\(offset)"
            }
            let resource = urlResource<DoneChallengeListResponseModel>(path: path)
            
            apiSession.getRequest(with: resource)
                .withUnretained(self)
                .subscribe(onNext: { owner, result in
                    switch result {
                    case .failure(let error):
                        owner.apiError.onError(error)
                    case .success(let data):
                        owner.output.doneChallengeList.accept(data.infos)
                        owner.output.isLastDoneChallenge.accept(data.isLast)
                        owner.output.nextOffsetDoneChallenge.accept(data.offset)
                    }
                })
                .disposed(by: bag)
        }
    }
}
