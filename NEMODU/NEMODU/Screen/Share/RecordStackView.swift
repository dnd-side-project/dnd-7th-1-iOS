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
    
    var distanceView = RecordView()
        .then {
            $0.recordTitle.text = "거리"
        }
    
    var timeView = RecordView()
        .then {
            $0.recordTitle.text = "시간"
        }
    
    var stepCntView = RecordView()
        .then {
            $0.recordTitle.text = "걸음수"
        }
    
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
        addSubview(recordStackView)
        [distanceView, timeView, stepCntView].forEach {
            $0.recordValue.font = .title3SB
            $0.recordTitle.font = .caption1
            recordStackView.addArrangedSubview($0)
        }
        
        recordStackView.addVerticalSeparators(color: .gray300,
                                              width: 1,
                                              multiplier: 0.2)
    }
}

// MARK: - Layout

extension RecordStackView {
    private func configureLayout() {
        recordStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [distanceView, timeView, stepCntView].forEach {
            $0.widthAnchor.constraint(equalToConstant: 86).isActive = true
        }
    }
}
