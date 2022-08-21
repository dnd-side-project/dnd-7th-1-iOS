//
//  RecordStackView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/13.
//

import UIKit
import SnapKit
import Then

class RecordStackView: BaseView {
    private let recordStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
    
    private var recordTitleLabel = UILabel()
        .then {
            $0.font = .body4
            $0.textColor = .gray900
        }
    
    var firstView = RecordView()
    var secondView = RecordView()
    var thirdView = RecordView()
    
    override func configureView() {
        super.configureView()
        configureRecordStackView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
}

// MARK: - Configure

extension RecordStackView {
    private func configureRecordStackView() {
        addSubviews([recordTitleLabel, recordStackView])
        [firstView, secondView, thirdView].forEach {
            $0.recordValue.font = .title2
            $0.recordTitle.font = .caption1
            $0.recordTitle.textColor = .gray600
            recordStackView.addArrangedSubview($0)
        }
        
        recordStackView.addVerticalSeparators(color: .gray300,
                                              width: 1,
                                              multiplier: 0.2)
    }
    
    /// stackView에 titleLabel을 추가하는 함수입니다.
    func configureStackViewTitle(title: String) {
        recordTitleLabel.text = title
        recordTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
}

// MARK: - Layout

extension RecordStackView {
    private func configureLayout() {
        recordStackView.snp.makeConstraints {
            $0.top.equalTo(recordTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        [firstView, secondView, thirdView].forEach {
            $0.widthAnchor.constraint(equalToConstant: 86).isActive = true
        }
    }
}
