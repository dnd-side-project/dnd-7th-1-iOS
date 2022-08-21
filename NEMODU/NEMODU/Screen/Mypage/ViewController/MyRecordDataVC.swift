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
                .withTintColor(.gray300, renderingMode: .alwaysOriginal), for: .normal)
        }
    
    private let prevWeekBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_left")?
                .withTintColor(.main, renderingMode: .alwaysOriginal), for: .normal)
        }
    
    private let recordStackView = RecordStackView()
        .then {
            $0.firstView.recordValue.text = "-"
            $0.secondView.recordValue.text = "-m"
            $0.thirdView.recordValue.text = "-:--"
            $0.firstView.recordTitle.text = "채운 칸의 수"
            $0.secondView.recordTitle.text = "거리"
            $0.thirdView.recordTitle.text = "시간"
        }
    
    private let calendar = FSCalendar()
        .then {
            $0.locale = Locale(identifier: "ko_KR")
            $0.headerHeight = 0
            $0.weekdayHeight = 40
            $0.firstWeekday = 2
            $0.scope = .week
            
            $0.appearance.weekdayFont = .body3
            $0.appearance.weekdayTextColor = .gray500
            
            $0.appearance.titleFont = .body1
            $0.appearance.titleDefaultColor = .gray300
            
            $0.appearance.selectionColor = .clear
            $0.appearance.titleSelectionColor = .black
            
            $0.appearance.titleTodayColor = .white
            $0.appearance.todaySelectionColor = .main
            $0.appearance.todayColor = .main
        }
    
    
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
        }
    
    private let naviBar = NavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scope = .week
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
        configureTitleDate()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
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
                          recordStackView,
                          calendar,
                          recordListView])
        recordListView.addSubviews([recordTitle,
                                    noneMessage,
                                    recordTableView])
        [recordStackView.firstView,
         recordStackView.secondView,
         recordStackView.thirdView].forEach {
            $0.recordValue.font = .title3SB
        }
        calendar.delegate = self
    }
    
    private func configureTitleDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        
        let week = Calendar.current.component(.weekOfMonth, from: Date.now)
        dateLabel.text = "\(dateFormatter.string(from: Date.now)) \(week)주차"
    }
}

// MARK: - Layout

extension MyRecordDataVC {
    private func configureLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        nextWeekBtn.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(24)
        }
        
        prevWeekBtn.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-24)
        }
        
        recordStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(recordStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(116)
        }
        
        recordListView.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom)
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
    
}

// MARK: - Output

extension MyRecordDataVC {
    
}

// MARK: - FSCalendarDelegate
extension MyRecordDataVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
}
