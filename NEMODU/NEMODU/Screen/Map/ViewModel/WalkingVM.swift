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
        
        var blocksCnt = PublishRelay<Int>()
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
    // TODO: - UserDefaults 수정
    func getBlocksCnt() {
        let nickname = "NickA"
        let path = "record/start?nickname=\(nickname)"
        let resource = urlResource<BlocksCntResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                dump(result)
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.blocksCnt.accept(data.areaNumber)
                }
            })
            .disposed(by: bag)
    }
}
