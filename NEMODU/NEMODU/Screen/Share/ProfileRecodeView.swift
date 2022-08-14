//
//  ProfileRecodeView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/14.
//

import UIKit
import Then
import SnapKit

class ProfileRecodeView: BaseView {
    var recodeTitle = UILabel()
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

    var recodeValue = UILabel()
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

extension ProfileRecodeView {
    private func configureContent() {
        addSubviews([recodeTitle, valueStackView])
        [recodeValue, valueUnit].forEach {
            valueStackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        recodeTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        valueStackView.snp.makeConstraints {
            $0.top.equalTo(recodeTitle.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
