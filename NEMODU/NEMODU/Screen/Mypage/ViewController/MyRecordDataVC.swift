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
    
    private let calendarCV = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        .then {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 4, bottom: 2, right: 4)
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 8
            
            $0.collectionViewLayout = layout
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.backgroundColor = .clear
        }
    
    private let calendarScopeBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_down"), for: .normal)
            $0.setImage(UIImage(named: "arrow_up"), for: .selected)
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
    
    private var isWeeklyScope = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMyRecordDataList(
            with: MyRecordListRequestModel(
                start: viewModel.startDateFormatter(viewModel.input.selectedDay.value),
                end: viewModel.endDateFormatter(viewModel.input.selectedDay.value)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCalendarHeight()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
        configureCalendarCV()
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
                          calendarSelectStackView,
                          calendarCV,
                          calendarScopeBtn,
                          recordListView])
        recordListView.addSubviews([recordTitle,
                                    noneMessage,
                                    recordTableView])
        
        calendarCV.delegate = self
        calendarCV.dataSource = self
        calendarCV.register(WeekCVC.self, forCellWithReuseIdentifier: WeekCVC.className)
        calendarCV.register(DayCVC.self, forCellWithReuseIdentifier: DayCVC.className)
        
        recordTableView.register(MyRecordListTVC.self, forCellReuseIdentifier: MyRecordListTVC.className)
        recordTableView.delegate = self
    }
    
    private func configureCalendarCV() {
        viewModel.getWeeklyDays()
        viewModel.getMonthlyDays()
        selectCV(date: .now)
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
    
    private func setCalendarHeight() {
        let height = calendarCV.collectionViewLayout.collectionViewContentSize.height
        
        calendarCV.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        calendarSelectStackView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        view.layoutIfNeeded()
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
        
        calendarCV.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(0)
        }
        
        calendarSelectStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(0)
        }
        
        calendarScopeBtn.snp.makeConstraints {
            $0.top.equalTo(calendarCV.snp.bottom)
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

// MARK: - Custom Methods

extension MyRecordDataVC {
    private func selectCV(date: Date) {
        if isWeeklyScope {
            calendarCV.selectItem(at: [1, date.getWeekDay()],
                                  animated: true,
                                  scrollPosition: .left)
        } else {
            let row = date.get(.day) + viewModel.firstDayOfMonth()!.getWeekDay() - 1
            calendarCV.selectItem(at: [1, row],
                                  animated: true,
                                  scrollPosition: .left)
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
                self.isWeeklyScope
                ? self.viewModel.input.moveWeek.accept(1)
                : self.viewModel.input.moveMonth.accept(1)
                self.calendarCV.reloadData()
                self.selectCV(date: self.viewModel.input.selectedDay.value)
            })
            .disposed(by: bag)
        
        prevWeekBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isWeeklyScope
                ? self.viewModel.input.moveWeek.accept(-1)
                : self.viewModel.input.moveMonth.accept(-1)
                self.calendarCV.reloadData()
                self.selectCV(date: self.viewModel.input.selectedDay.value)
            })
            .disposed(by: bag)
        
        calendarScopeBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if !self.isWeeklyScope { self.viewModel.getWeeklyDays() }
                self.calendarSelectStackView.isHidden = self.isWeeklyScope
                self.calendarScopeBtn.isSelected = self.isWeeklyScope
                self.isWeeklyScope.toggle()
                self.calendarCV.reloadData()
                self.setCalendarHeight()
                self.selectCV(date: self.viewModel.input.selectedDay.value)
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
                self.calendarSelectStackView.setSelectDay(dayIndex: day.getWeekDay())
                
                // 일자별 tableView 연결
                self.viewModel.getMyRecordDataList(
                    with: MyRecordListRequestModel(start: self.viewModel.startDateFormatter(day),
                                                   end: self.viewModel.endDateFormatter(day)))
                self.recordTableView.reloadData()
            })
            .disposed(by: bag)
        
        calendarCV.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] idx in
                guard let self = self,
                      let dayCell = self.calendarCV.cellForItem(at: idx) as? DayCVC,
                      let selectedDate = dayCell.date
                else { return }
                // 다른 달을 눌렀을 때, 이번 달을 눌렀을 때 선택 상태 및 캘린더 상태 구분
                if self.viewModel.input.selectedDay.value.get(.month) == selectedDate.get(.month) {
                    self.viewModel.input.selectedDay.accept(selectedDate)
                    self.calendarCV.reloadData()
                    self.calendarCV.selectItem(at: idx,
                                               animated: true,
                                               scrollPosition: .left)
                } else {
                    self.viewModel.input.selectedDay.accept(selectedDate)
                    self.viewModel.getMonthlyDays()
                    self.calendarCV.reloadData()
                    self.selectCV(date: selectedDate)
                }
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // 미래 선택 불가능
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCVC,
              let selectedDate = cell.date else { return false }
        return selectedDate <= .now
    }
}

// MARK: - UICollectionViewDelegate

extension MyRecordDataVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 32) / 7 - 8
        
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: 18)
        default:
            return CGSize(width: width, height: width)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MyRecordDataVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        default:
            return isWeeklyScope ? viewModel.weekDays.count : viewModel.days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let weekCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCVC.className, for: indexPath) as? WeekCVC,
              let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCVC.className, for: indexPath) as? DayCVC
        else { fatalError() }
        
        switch indexPath.section {
        case 0:
            weekCell.configureCell(viewModel.weekTitle[indexPath.row])
            return weekCell
        default:
            let day = isWeeklyScope ? viewModel.weekDays[indexPath.row] : viewModel.days[indexPath.row]
            dayCell.configureCell(day)
            
            // 이전달, 다음달 일자 색상 변경
            if day.get(.month) != viewModel.input.selectedDay.value.get(.month) {
                dayCell.setOtherMonthDate()
            }
            
            return dayCell
        }
    }
}
