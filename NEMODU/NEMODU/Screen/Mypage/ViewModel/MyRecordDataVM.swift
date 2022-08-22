//
//  MyRecordDataVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/22.
//

import Foundation
import RxCocoa
import RxSwift

protocol MypageRecordDataViewModelOutput: Lodable {
    var myRecordList: BehaviorRelay<[ActivityRecord]> { get }
    var myRecordData: PublishRelay<MyRecordListResponseModel> { get }
    var dataSource: Observable<[MyRecordListDataSource]> { get }
}

final class MyRecordDataVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: MypageRecordDataViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        var myRecordData = PublishRelay<MyRecordListResponseModel>()
        var myRecordList = BehaviorRelay<[ActivityRecord]>(value: [])
        var dataSource: Observable<[MyRecordListDataSource]> {
            myRecordList
                .map {
                    [MyRecordListDataSource(section: .zero, items: $0)]
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

// MARK: - Custom Methods

extension MyRecordDataVM {
    func startDateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        let date = dateFormatter.string(from: Date.now)
        return date + "00:00:00"
    }
    
    func endDateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        let date = dateFormatter.string(from: Date.now)
        return date + "23:59:59"
    }
}

// MARK: - Input

extension MyRecordDataVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension MyRecordDataVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension MyRecordDataVM {
    func getMyRecordDataList(with param: MyRecordListRequestModel) {
        let path = "user/info/activity"
        let resource = urlResource<MyRecordListResponseModel>(path: path)
        
        apiSession.postRequest(with: resource, param: param.recordParam)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.myRecordData.accept(data)
                    owner.output.myRecordList.accept(data.activityRecords)
                }
            })
            .disposed(by: bag)
    }
}
