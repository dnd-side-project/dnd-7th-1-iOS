//
//  MyRecordDetailVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/23.
//

import Foundation
import RxCocoa
import RxSwift

protocol MyRecordDetailViewModelOutput: Lodable {
    var detailData: PublishRelay<DetailRecordDataResponseModel> { get }
}

final class MyRecordDetailVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: MyRecordDetailViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        var detailData = PublishRelay<DetailRecordDataResponseModel>()
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

extension MyRecordDetailVM {}

// MARK: - Input

extension MyRecordDetailVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension MyRecordDetailVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension MyRecordDetailVM {
    func getMyRecordDetailData(recordId: Int) {
        let path = "user/info/activity/record?recordId=\(recordId)"
        let resource = urlResource<DetailRecordDataResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    self.output.detailData.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
