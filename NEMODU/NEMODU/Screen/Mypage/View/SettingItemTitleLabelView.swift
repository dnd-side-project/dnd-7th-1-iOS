//
//  SettingItemTitleLabelView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SettingItemTitleLabelView: BaseView {
    
    // MARK: - UI components
    
    private let titleLabel = PaddingLabel()
        .then {
            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.text = "----"
            $0.font = .body1
            $0.textColor = .gray900

            $0.backgroundColor = .white
        }
    private let borderLineView = UIView()
        .then {
            $0.backgroundColor = .gray200
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
}

// MARK: - Configure

extension SettingItemTitleLabelView {
    
    /// Setting Item Title Label의 제목을 입력하는 함수
    func setTitle(settingItemTitle: String) {
        titleLabel.text = settingItemTitle
    }
    
}

// MARK: - Layout

extension SettingItemTitleLabelView {
    
    private func configureLayout() {
        addSubviews([titleLabel,
                     borderLineView])
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(56.0)
            
            $0.edges.equalTo(self)
        }
        borderLineView.snp.makeConstraints {
            $0.height.equalTo(1.0)

            $0.bottom.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalTo(titleLabel)
        }
    }
    
}
