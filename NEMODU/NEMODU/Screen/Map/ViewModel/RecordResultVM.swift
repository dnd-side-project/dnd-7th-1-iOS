//
//  RecordResultVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/19.
//

import Foundation
import RxCocoa
import RxSwift

protocol RecordResultViewModelOutput: Lodable {
    var isValidPost: PublishSubject<Bool> { get }
}

final class RecordResultVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: RecordResultViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        var isValidPost = PublishSubject<Bool>()
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

extension RecordResultVM {}

// MARK: - Input

extension RecordResultVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension RecordResultVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension RecordResultVM {
    func postRecordData(with record: RecordDataRequest) {
        let path = "record/end"
        let resource = urlResource<Bool>(path: path)
        
        output.beginLoading()
        apiSession.postRequest(with: resource,
                               param: record.recordParam)
        .withUnretained(self)
        .subscribe(onNext: { owner, result in
            switch result {
            case .failure(let error):
                owner.apiError.onNext(error)
            case .success(let data):
                owner.output.isValidPost.onNext(data)
            }
            owner.output.endLoading()
        })
        .disposed(by: bag)
    }
}
