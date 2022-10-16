//
//  EditRecordMemoVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/11.
//

import Foundation
import RxCocoa
import RxSwift

final class EditRecordMemoVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var isValidEdit = PublishRelay<Bool>()
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

extension EditRecordMemoVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension EditRecordMemoVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension EditRecordMemoVM {
    func postEditedData(with memo: EditMemoRequestModel) {
        let path = "user/info/activity/record/edit"
        let resource = urlResource<Bool>(path: path)
        
        apiSession.postRequest(with: resource, param: memo.memoParam)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.isValidEdit.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
