//
//  WalkingVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/09.
//

import Foundation
import RxCocoa
import RxSwift

final class WalkingVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        let driver = Driver<Int>
            .interval(.seconds(1))
            .map { _ in
                return 1
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

extension WalkingVM {}

// MARK: - Input

extension WalkingVM: Input {
    func bindInput() { }
}

// MARK: - Output

extension WalkingVM: Output {
    func bindOutput() { }
}
