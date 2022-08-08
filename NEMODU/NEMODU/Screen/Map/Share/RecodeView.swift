//
//  RecodeView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/08.
//

import UIKit
import Then
import SnapKit

class RecodeView: BaseView {
    var recodeValue = UILabel()
        .then {
            $0.font = UIFont.systemFont(ofSize: 34)
        }
    
    var recodeTitle = UILabel()
        .then {
            $0.font = UIFont.systemFont(ofSize: 12)
        }
    
    var recodeSubtitle = UILabel()
        .then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.lightGray
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

extension RecodeView {
    private func configureContent() {
        addSubviews([recodeValue, recodeTitle, recodeSubtitle])
    }
    
    private func configureLayout() {
        recodeValue.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(41)
            $0.centerX.equalToSuperview()
        }
        
        recodeTitle.snp.makeConstraints {
            $0.top.equalTo(recodeValue.snp.bottom).offset(10)
            $0.height.equalTo(14)
            $0.centerX.equalToSuperview()
        }
        
        recodeSubtitle.snp.makeConstraints {
            $0.top.equalTo(recodeTitle.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}
