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
    
    struct Input {
        var selectedDay = BehaviorRelay<Date>(value: Date.now)
        var moveWeek = PublishRelay<Int>()
    }
    
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
    func startDateFormatter(_ today: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        let date = dateFormatter.string(from: today)
        return date
    }
    
    func endDateFormatter(_ today: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'23:59:59"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        let date = dateFormatter.string(from: today)
        return date
    }
    
    func setSelected(date: Date) -> Int {
        var dayIndex = Calendar.current.component(.weekday, from: date) - 2
        dayIndex = dayIndex < 0 ? 6 : dayIndex
        return dayIndex
    }
    
    func isToday(_ date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date) == dateFormatter.string(from: Date.now)
    }
}

// MARK: - Input

extension MyRecordDataVM: Input {
    func bindInput() {
        input.moveWeek
            .subscribe(onNext: { [weak self] value in
                guard let self = self,
                      let selectedDate = Calendar.current.date(byAdding: .weekOfMonth,
                                                               value: value,
                                                               to: self.input.selectedDay.value)
                else { return }
                self.input.selectedDay.accept(selectedDate > .now ? .now : selectedDate)
            })
            .disposed(by: bag)
    }
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
