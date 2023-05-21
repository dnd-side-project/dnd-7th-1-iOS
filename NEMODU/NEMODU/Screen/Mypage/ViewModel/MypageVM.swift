//
//  MypageVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol MypageViewModelOutput: Lodable {
    var userData: PublishRelay<MypageUserDataResponseModel> { get }
}

final class MypageVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: MypageViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        var userData = PublishRelay<MypageUserDataResponseModel>()
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

extension MypageVM {}

// MARK: - Input

extension MypageVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension MypageVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension MypageVM {
    func getMypageData() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "user/info?nickname=\(nickname)"
        let resource = urlResource<MypageUserDataResponseModel>(path: path)
        
        output.beginLoading()
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.userData.accept(data)
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
}
