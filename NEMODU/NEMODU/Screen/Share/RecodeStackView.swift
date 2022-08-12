//
//  RecodeStackView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/13.
//

import UIKit
import SnapKit
import Then

class RecodeStackView: BaseView {
    private let recodeStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
    
    var distanceView = RecodeView()
        .then {
            $0.recodeValue.font = .title3SB
            $0.recodeTitle.font = .caption1
            $0.recodeTitle.text = "거리"
        }
    
    var timeView = RecodeView()
        .then {
            $0.recodeValue.font = .title3SB
            $0.recodeTitle.font = .caption1
            $0.recodeTitle.text = "시간"
        }
    
    var stepCntView = RecodeView()
        .then {
            $0.recodeValue.font = .title3SB
            $0.recodeTitle.font = .caption1
            $0.recodeTitle.text = "걸음수"
        }
    
    override func configureView() {
        super.configureView()
        configureRecodeStackView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
}

// MARK: - Configure

extension RecodeStackView {
    private func configureRecodeStackView() {
        addSubview(recodeStackView)
        [distanceView, timeView, stepCntView].forEach {
            recodeStackView.addArrangedSubview($0)
        }
        recodeStackView.addVerticalSeparators(color: .gray300,
                                              width: 1,
                                              multiplier: 0.2)
    }
}

// MARK: - Layout

extension RecodeStackView {
    private func configureLayout() {
        recodeStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [distanceView, timeView, stepCntView].forEach {
            $0.widthAnchor.constraint(equalToConstant: 86).isActive = true
        }
    }
}
