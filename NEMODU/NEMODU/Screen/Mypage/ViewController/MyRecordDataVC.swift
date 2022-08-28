//
//  MyRecordDataVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/22.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import RxDataSources
import SnapKit
import Then
import FSCalendar

class MyRecordDataVC: BaseViewController {
    private let dateLabel = UILabel()
        .then {
            $0.textColor = .gray900
            $0.font = .title3M
            $0.textAlignment = .center
        }
    
    private let nextWeekBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_right")?
                .withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray300
            $0.isUserInteractionEnabled = false
        }
    
    private let prevWeekBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_left")?
                .withTintColor(.main, renderingMode: .alwaysOriginal), for: .normal)
        }
    
    private let calendar = FSCalendar()
        .then {
            $0.locale = Locale(identifier: "ko_KR")
            $0.headerHeight = 0
            $0.weekdayHeight = 32
            $0.firstWeekday = 2
            $0.scope = .week
            
            $0.appearance.weekdayFont = .body3
            $0.appearance.weekdayTextColor = .gray500
            
            $0.appearance.titleFont = .body1
            $0.appearance.titleDefaultColor = .gray400
            
            $0.appearance.selectionColor = .clear
            $0.appearance.titleSelectionColor = .black
            
            $0.appearance.titleTodayColor = .white
            $0.appearance.todaySelectionColor = .main
            $0.appearance.todayColor = .main
            
            $0.collectionView.isScrollEnabled = false
        }
    
    private let calendarScopeBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_down"), for: .normal)
        }
    
    private let calendarSelectStackView = CalendarSelectStackView()
    
    private let recordListView = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    private let recordTitle = UILabel()
        .then {
            $0.text = "활동 내역"
            $0.font = .title3SB
            $0.textColor = .gray900
        }
    
    private let noneMessage = UILabel()
        .then {
            $0.text = "기록이 없습니다."
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    private let recordTableView = UITableView(frame: .zero)
        .then {
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
        }
    
    private let naviBar = NavigationBar()
    
    private let viewModel = MyRecordDataVM()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMyRecordDataList(
            with: MyRecordListRequestModel(start: viewModel.startDateFormatter(calendar.selectedDate ?? Date.now),
                                           end: viewModel.endDateFormatter(calendar.selectedDate ?? Date.now)))
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
        configureTitleDate(.now)
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindBtn()
        bindDaySelect()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindTableView()
    }
    
}

// MARK: - Configure

extension MyRecordDataVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: "나의 활동 기록")
        naviBar.configureBackBtn(targetVC: self)
    }
    
    private func configureContentView() {
        view.addSubviews([dateLabel,
                          nextWeekBtn,
                          prevWeekBtn,
                          calendar,
                          calendarScopeBtn,
                          recordListView])
        recordListView.addSubviews([recordTitle,
                                    noneMessage,
                                    recordTableView])
        
        calendar.delegate = self
        calendar.contentView.addSubview(calendarSelectStackView)
        calendar.contentView.sendSubviewToBack(calendarSelectStackView)
        
        recordTableView.register(MyRecordListTVC.self, forCellReuseIdentifier: MyRecordListTVC.className)
        recordTableView.delegate = self
    }
    
    private func configureTitleDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        dateLabel.text = "\(dateFormatter.string(from: date))"
    }
    
    private func setNextWeekBtn(_ date: Date) {
        let active = Calendar.current.compare(date, to: .now, toGranularity: .weekOfYear) == .orderedSame ? false : true
        nextWeekBtn.isUserInteractionEnabled = active
        nextWeekBtn.tintColor = active ? .main : .gray300
    }
}

// MARK: - Layout

extension MyRecordDataVC {
    private func configureLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(60)
        }
        
        nextWeekBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.width.height.equalTo(24)
        }
        
        prevWeekBtn.snp.makeConstraints {
            $0.centerY.equalTo(nextWeekBtn.snp.centerY)
            $0.trailing.equalTo(nextWeekBtn.snp.leading).offset(-24)
            $0.width.height.equalTo(24)
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(400)
        }
        
        calendarSelectStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        calendarScopeBtn.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        recordListView.snp.makeConstraints {
            $0.top.equalTo(calendarScopeBtn.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        recordTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        noneMessage.snp.makeConstraints {
            $0.top.equalTo(recordTitle.snp.bottom).offset(44)
            $0.centerX.equalToSuperview()
        }
        
        recordTableView.snp.makeConstraints {
            $0.top.equalTo(recordTitle.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension MyRecordDataVC {
    private func bindBtn() {
        nextWeekBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.input.moveWeek.accept(1)
                self.calendar.select(self.viewModel.input.selectedDay.value, scrollToDate: true)
            })
            .disposed(by: bag)
        
        prevWeekBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.input.moveWeek.accept(-1)
                self.calendar.select(self.viewModel.input.selectedDay.value, scrollToDate: true)
            })
            .disposed(by: bag)
        
        calendarScopeBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                // TODO: - Change calendar scope
            })
            .disposed(by: bag)
    }
    
    private func bindDaySelect() {
        viewModel.input.selectedDay
            .subscribe(onNext: { [weak self] day in
                guard let self = self else { return }
                // title 연결
                self.configureTitleDate(day)
                
                // 다음주 버튼 활성화 상태
                self.setNextWeekBtn(day)
                
                // 선택 일자 배경 지정
                self.calendarSelectStackView.setSelectDay(dayIndex: self.viewModel.setSelected(date: day))
                
                // 선택 일자 색 구별
                self.calendar.appearance.titleSelectionColor
                = self.viewModel.isToday(day)
                ? .white : .black
                
                // 일자별 tableView 연결
                self.viewModel.getMyRecordDataList(
                    with: MyRecordListRequestModel(start: self.viewModel.startDateFormatter(day),
                                                   end: self.viewModel.endDateFormatter(day)))
                self.recordTableView.reloadData()
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MyRecordDataVC {
    private func bindTableView() {
        viewModel.output.dataSource
            .bind(to: recordTableView.rx.items(dataSource: tableViewDataSource()))
            .disposed(by: bag)
        
        recordTableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self,
                      let cell = self.recordTableView.cellForRow(at: indexPath) as? MyRecordListTVC,
                      let recordID = cell.recordID
                else { return }
                let myRecordDetailVC = MyRecordDetailVC()
                myRecordDetailVC.recordID = recordID
                self.navigationController?.pushViewController(myRecordDetailVC, animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - DataSource

extension MyRecordDataVC {
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<MyRecordListDataSource> {
        RxTableViewSectionedReloadDataSource<MyRecordListDataSource>(configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MyRecordListTVC.className,
                for: indexPath
            ) as? MyRecordListTVC else {
                fatalError()
            }
            cell.configureCell(with: item)
            return cell
        })
    }
}

// MARK: - UITableViewDelegate

extension MyRecordDataVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76.0 + 12.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - FSCalendarDelegate

extension MyRecordDataVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(90)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 날짜 선택
        viewModel.input.selectedDay.accept(date)
    }
    
    // 미래 선택 불가능
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        !(date > .now)
    }
}

// MARK: - FSCalendarDelegateAppearance

extension MyRecordDataVC: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if viewModel.isToday(date) { return .white }
        else { return date > .now ? .gray300 : .gray400}
    }
}
