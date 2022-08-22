//
//  RecordView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/08.
//

import UIKit
import Then
import SnapKit

class RecordView: BaseView {
    var recordValue = UILabel()
        .then {
            $0.font = .title1
            $0.textColor = .gray900
        }
    
    var recordTitle = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray800
        }
    
    var recordSubtitle = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray500
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

extension RecordView {
    private func configureContent() {
        addSubviews([recordValue, recordTitle, recordSubtitle])
    }
    
    private func configureLayout() {
        recordValue.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        recordTitle.snp.makeConstraints {
            $0.top.equalTo(recordValue.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        recordSubtitle.snp.makeConstraints {
            $0.top.equalTo(recordTitle.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
