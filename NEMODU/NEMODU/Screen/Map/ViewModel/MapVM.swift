//
//  MapVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import RxCocoa
import RxSwift

final class MapVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {}
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
}

// MARK: - Helpers

extension MapVM {}

// MARK: - Input

extension MapVM: Input {}

// MARK: - Output

extension MapVM: Output {}
