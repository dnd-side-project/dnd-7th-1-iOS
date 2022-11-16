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
        
        var invitedChallengeList = PublishRelay<InvitedChallengeListResponseModel>()
        
        var waitChallengeList = PublishRelay<WaitChallengeListResponseModel>()
        var progressChallengeList = PublishRelay<ProgressAndDoneChallengeListResponseModel>()
        var doneChallengeList = PublishRelay<ProgressAndDoneChallengeListResponseModel>()
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
    func getInvitedChallengeList() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "challenge/invite?nickname=\(nickname)"
        let resource = urlResource<InvitedChallengeListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.invitedChallengeList.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func getWaitChallengeList() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
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
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "challenge/progress?nickname=\(nickname)"
        let resource = urlResource<ProgressAndDoneChallengeListResponseModel>(path: path)
        
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
    
    func getDoneChallengeList() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "challenge/done?nickname=\(nickname)"
        let resource = urlResource<ProgressAndDoneChallengeListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.doneChallengeList.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
