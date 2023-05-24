//
//  RankingListVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/17.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class RankingListVC : BaseViewController {
    
    // MARK: - UI components
    
    let weeksNavigationView = UIView()
    private lazy var previousWeekButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray900
        }
    private let weeksNavigationLabel = UILabel()
        .then {
            $0.text = "----.-- -주차"
            $0.font = .boldSystemFont(ofSize: 18)
            $0.textColor = .gray900
        }
    private lazy var nextWeekButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray900
        }
    
    let myRankingView = RankingUserView()
    
    private let rankingHeaderBorderLineView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }
    
    let rankingTableView = UITableView(frame: .zero, style: .grouped)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
            
            $0.sectionHeaderHeight = 24.0
            $0.rowHeight = 84.0
            $0.sectionFooterHeight = .leastNormalMagnitude
        }
        
    // MARK: - Variables and Properties
    
    var selectedDate: Date = .now

    let myUserNickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureWeeksNavigation(targetDate: 0)
    }
    override func configureView() {
        super.configureView()
        
        configureTableView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    // MARK: - Functions
    
    func configureWeeksNavigation(targetDate: Int) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        
        let week = DateComponents(day: targetDate)
        selectedDate = calendar.date(byAdding: week, to: selectedDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        let weekOfMonth = calendar.component(.weekOfMonth, from: selectedDate)
        weeksNavigationLabel.text = "\(dateFormatter.string(from: selectedDate)) \(weekOfMonth)주차"
        
        let active = Calendar.current.compare(.now, to: selectedDate, toGranularity: .weekOfYear) == .orderedSame ? false : true
        nextWeekButton.isUserInteractionEnabled = active
        nextWeekButton.tintColor = active ? .gray900 : .gray300
    }
    
    func configureTableView() { }
    
    func makeDateByFormat() -> [String] {
        let calendar = Calendar(identifier: .gregorian)
        let currentDayNum = calendar.component(.weekday, from: selectedDate)

        let mondayNum = 2 - currentDayNum
        guard let mondayDate = calendar.date(byAdding: .day, value: mondayNum, to: selectedDate) else { return [] }
        var startDate = mondayDate.toString(separator: .withT)
        startDate.append("00:00:00")

        let sundayNum = 8 - currentDayNum
        guard let sundayDate = calendar.date(byAdding: .day, value: sundayNum, to: selectedDate) else { return [] }
        var endDate = sundayDate.toString(separator: .withT)
        endDate.append("23:59:59")
        
        var result: [String] = []
        result.append(startDate)
        result.append(endDate)
        
        return result
    }
    
}

// MARK: - Layout

extension RankingListVC {
    
    private func configureLayout() {
        view.addSubviews([weeksNavigationView,
                          myRankingView,
                          rankingHeaderBorderLineView,
                          rankingTableView])
        weeksNavigationView.addSubviews([previousWeekButton, weeksNavigationLabel, nextWeekButton])
        
        
        weeksNavigationView.snp.makeConstraints {
            $0.height.equalTo(60)
            
            $0.top.horizontalEdges.equalTo(view)
        }
        previousWeekButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(previousWeekButton.snp.width)
            
            $0.centerY.equalTo(weeksNavigationLabel)
            $0.right.equalTo(weeksNavigationLabel.snp.left).inset(-24)
        }
        weeksNavigationLabel.snp.makeConstraints {
            $0.center.equalTo(weeksNavigationView)
        }
        nextWeekButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(nextWeekButton.snp.width)
            
            $0.centerY.equalTo(weeksNavigationLabel)
            $0.left.equalTo(weeksNavigationLabel.snp.right).offset(24)
        }
        
        myRankingView.snp.makeConstraints {
            $0.top.equalTo(weeksNavigationView.snp.bottom)
            $0.horizontalEdges.equalTo(view)
        }
        rankingHeaderBorderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.top.equalTo(myRankingView.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(view)
        }
        rankingTableView.snp.makeConstraints {
            $0.top.equalTo(rankingHeaderBorderLineView.snp.bottom)
            $0.horizontalEdges.equalTo(view)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
}

// MARK: - Input

extension RankingListVC {
    
    private func bindButton() {
        previousWeekButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.configureWeeksNavigation(targetDate: -7)
            })
            .disposed(by: disposeBag)
        
        nextWeekButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.configureWeeksNavigation(targetDate: 7)
            })
            .disposed(by: disposeBag)
    }
    
}
