//
//  ChallengePeriodVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/25.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengePeriodVC: CreateChallengeVC {
    
    // MARK: - UI components
    
    private let containerView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }
    
    private lazy var startChallengeButtonView = ChallengeTermButtonView()
        .then {
            $0.titleLabel.text = "챌린지 시작일"
            $0.actionButton.addTarget(self, action: #selector(didTapStartChallengeButton), for: .touchUpInside)
        }
    
    private let datePickerContainerView = UIView()
        .then {
            $0.clipsToBounds = true
        }
    private lazy var datePicker = UIDatePicker()
        .then {
            $0.preferredDatePickerStyle = .wheels
            $0.datePickerMode = .date
            $0.locale = Locale(identifier: "ko-KR")
            $0.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            
            $0.backgroundColor = .white
            
            $0.addTarget(self, action: #selector(didDateSelected), for: .valueChanged)
        }
    
    private lazy var endChallengeButtonView = ChallengeTermButtonView()
        .then {
            $0.titleLabel.text = "챌린지 종료일"
        }
    
    private let guideLabel = PaddingLabel()
        .then {
            $0.text = "모든 챌린지는 시작날짜 00시 00분에 시작하여 \n해당 주 일요일 23시 59분에 종료됩니다."
            $0.numberOfLines = 2
            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            $0.font = .caption1
            $0.textColor = .gray400
            
            $0.backgroundColor = .white
        }
    
    // MARK: - Variables and Properties
    
    var createWeekChallengeVC: CreateWeekChallengeVC?
    
    private var datePickerContainerHeightConstraint: Constraint?
    
    private var started, ended: String?
    private var startedDate: Date?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if started != nil {
            didDateSelected()
        }
    }
    
    override func configureView() {
        super.configureView()
        
        _ = navigationBar
            .then {
                $0.naviType = .present
                $0.configureNaviBar(targetVC: self, title: "챌린지 기간 설정")
                $0.configureBackBtn(targetVC: self)
            }
        
        _ = confirmButton
            .then {
                $0.setTitle("완료", for: .normal)
                $0.isEnabled = true
            }
    }
    
    override func layoutView() {
        super.layoutView()
        
        view.addSubview(containerView)
        view.addSubviews([startChallengeButtonView, datePickerContainerView, datePicker, endChallengeButtonView, guideLabel])
        
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view)
            $0.bottom.lessThanOrEqualTo(view.snp.bottom)
        }
        
        startChallengeButtonView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.horizontalEdges.equalTo(view)
        }
        datePickerContainerView.snp.makeConstraints {
            datePickerContainerHeightConstraint = $0.height.equalTo(0).constraint
            
            $0.top.equalTo(startChallengeButtonView.snp.bottom)
            $0.horizontalEdges.equalTo(view)
        }
        datePicker.snp.makeConstraints {
            $0.edges.equalTo(datePickerContainerView)
        }
        endChallengeButtonView.snp.makeConstraints {
            $0.top.equalTo(datePickerContainerView.snp.bottom).offset(1)
            $0.horizontalEdges.equalTo(view)
        }
        guideLabel.snp.makeConstraints {
            $0.height.equalTo(58)
            
            $0.top.equalTo(endChallengeButtonView.snp.bottom).offset(1)
            $0.horizontalEdges.equalTo(view)
        }
    }
    
    // MARK: - Functions
    
    @objc
    private func didTapStartChallengeButton() {
        if datePickerContainerHeightConstraint?.layoutConstraints[0].constant == 0 {
            datePickerContainerHeightConstraint?.layoutConstraints[0].constant = 183
            datePicker.isHidden = false
        } else {
            datePicker.isHidden = true
            datePickerContainerHeightConstraint?.layoutConstraints[0].constant = 0
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: { [self] in
            self.view.layoutIfNeeded()
            didDateSelected()
        })
    }
    
    @objc
    private func didDateSelected() {
        // 날짜 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        startedDate = datePicker.date
        let selectedDate = datePicker.date
        started = dateFormatter.string(from: selectedDate)
        startChallengeButtonView.settingLabel.text = started
        
        let calendar = Calendar(identifier: .gregorian)
        
        // 일...토까지 1...7로 번호 구성
        let currentDayNum = calendar.component(.weekday, from: selectedDate)
        let addDayToSunday = 8 - currentDayNum
        let afterSelectedDate = calendar.date(byAdding: .day, value: addDayToSunday, to: selectedDate)
        ended = dateFormatter.string(from: afterSelectedDate!)
        endChallengeButtonView.settingLabel.text = ended
        
        confirmButton.isSelected = true
    }
    
    override func didTapConfirmButton() {
        // 선택된 날짜 챌린지 생성 VC로 전달하기
        createWeekChallengeVC?.started = started
        createWeekChallengeVC?.ended = ended
        createWeekChallengeVC?.startedDate = startedDate
        
        dismiss(animated: true)
    }
    
}
