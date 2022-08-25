//
//  ProfileRecordStackView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/14.
//

import UIKit
import SnapKit
import Then

class ProfileRecordStackView: BaseView {
    private let stackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 8
        }
    
    var firstView = ProfileRecordView()
    var secondView = ProfileRecordView()
    var thirdView = ProfileRecordView()
    
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

extension ProfileRecordStackView {
    private func configureRecordStackView() {
        addSubview(stackView)
        [firstView, secondView, thirdView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    /// stackView 세 영역의 값을 지정하는 함수입니다.
    func setRecordData(value1: String, value2: String, value3: String) {
        firstView.recordValue.text = value1
        secondView.recordValue.text = value2
        thirdView.recordValue.text = value3
    }
}

// MARK: - Layout

extension ProfileRecordStackView {
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
