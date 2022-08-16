//
//  ProfileRecordView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/14.
//

import UIKit
import Then
import SnapKit

class ProfileRecordView: BaseView {
    var recordTitle = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
    
    var valueStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }

    var recordValue = UILabel()
        .then {
            $0.font = .title1
            $0.textColor = .gray900
            $0.textAlignment = .center
            $0.text = "-"
        }
    
    var valueUnit = UILabel()
        .then {
            $0.font = .body1
            $0.textColor = .gray700
            $0.textAlignment = .center
        }
    
    override func configureView() {
        super.configureView()
        configureContent()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
}

// MARK: - Configure

extension ProfileRecordView {
    private func configureContent() {
        addSubviews([recordTitle, valueStackView])
        [recordValue, valueUnit].forEach {
            valueStackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        recordTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        valueStackView.snp.makeConstraints {
            $0.top.equalTo(recordTitle.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
