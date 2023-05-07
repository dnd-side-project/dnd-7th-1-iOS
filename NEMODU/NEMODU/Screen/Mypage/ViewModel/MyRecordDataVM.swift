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
    var dataSource: Observable<[MyRecordListDataSource]> { get }
}

final class MyRecordDataVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // Calendar
    private let cal = Calendar.current
    private var components = DateComponents()
    let weekTitle = ["월", "화", "수", "목", "금", "토", "일"]
    var days = [Date]()
    var weekDays = [Date]()
    var eventDays = [String]()
    
    // MARK: - Input
    
    struct Input {
        var selectedDay = BehaviorRelay<Date>(value: Date.now)
        var moveWeek = PublishRelay<Int>()
        var moveMonth = PublishRelay<Int>()
    }
    
    // MARK: - Output
    
    struct Output: MypageRecordDataViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        var myRecordList = BehaviorRelay<[ActivityRecord]>(value: [])
        var dataSource: Observable<[MyRecordListDataSource]> {
            myRecordList
                .map {
                    [MyRecordListDataSource(section: .zero, items: $0)]
                }
        }
        var calendarReload = PublishSubject<Bool>()
        var isRecordEmpty = PublishRelay<Bool>()
    }
    
    // MARK: - Init
    
    init() {
        configureDateComponents()
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Custom Methods

extension MyRecordDataVM {
    
    private func configureDateComponents() {
        components.year = cal.component(.year, from: .now)
        components.month = cal.component(.month, from: .now)
        components.day = 1
    }
    
    func getWeeklyDays() {
        let weekDay = input.selectedDay.value.getWeekDay()
        
        weekDays.removeAll()
        for i in 0..<7 {
            weekDays.append(cal.date(byAdding: .day,
                                     value: i - weekDay,
                                     to: input.selectedDay.value)!)
        }
    }
    
    func getMonthlyDays() {
        guard let firstDayOfMonth = firstDayOfMonth() else { return }
        
        days.removeAll()
        for i in 0..<42 {
            days.append(cal.date(byAdding: .day,
                                 value: i - firstDayOfMonth.getWeekDay(),
                                 to: firstDayOfMonth)!)
        }
    }
    
    func getEventDays(_ yearMonth: Date) {
        getEventList(yearMonth: yearMonth.toString(separator: .hyphen))
    }
    
    func firstDayOfMonth() -> Date? {
        guard let interval = cal.dateInterval(of: .month, for: input.selectedDay.value) else { return nil }
        return interval.start
    }
    
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
}

// MARK: - Input

extension MyRecordDataVM: Input {
    func bindInput() {
        input.moveWeek
            .subscribe(onNext: { [weak self] value in
                guard let self = self,
                      let selectedDate = self.cal.date(byAdding: .weekOfMonth,
                                                       value: value,
                                                       to: self.input.selectedDay.value)
                else { return }
                if self.input.selectedDay.value.get(.month) != selectedDate.get(.month) {
                    self.getEventDays(selectedDate)
                }
                self.input.selectedDay.accept(selectedDate > .now ? .now : selectedDate)
                self.getWeeklyDays()
                self.getMonthlyDays()
            })
            .disposed(by: bag)
        
        input.moveMonth
            .subscribe(onNext: { [weak self] value in
                guard let self = self,
                      let selectedDate = self.cal.date(byAdding: .month,
                                                       value: value,
                                                       to: self.input.selectedDay.value)
                else { return }
                self.input.selectedDay.accept(selectedDate > .now ? .now : selectedDate)
                self.getEventDays(self.input.selectedDay.value)
                self.getWeeklyDays()
                self.getMonthlyDays()
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
    func getEventList(yearMonth: String) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "user/event-list?nickname=\(nickname)&yearMonth=\(yearMonth)"
        let resource = urlResource<EventListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.eventDays.removeAll()
                    owner.eventDays = data.eventList
                    owner.output.calendarReload.onNext(true)
                }
            })
            .disposed(by: bag)
    }
    
    func getMyRecordDataList(started: String, ended: String) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "user/info/activity?nickname=\(nickname)&started=\(started)&ended=\(ended)"
        let resource = urlResource<MyRecordListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.isRecordEmpty.accept(data.activityRecords.count == 0)
                    owner.output.myRecordList.accept(data.activityRecords)
                }
            })
            .disposed(by: bag)
    }
}
