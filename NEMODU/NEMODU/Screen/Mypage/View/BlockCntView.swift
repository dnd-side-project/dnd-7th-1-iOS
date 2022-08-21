//
//  BlockCntView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/21.
//

import UIKit
import SnapKit
import Then

class BlockCntView: BaseView {
    private let titleLabel = UILabel()
        .then {
            $0.text = "전체 누적 칸"
            $0.font = .body4
            $0.textColor = .gray900
        }
    
    private let blockCnt = UILabel()
        .then {
            $0.text = "- 칸"
            $0.font = .title2
            $0.textColor = .gray900
        }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
}

// MARK: - Configure

extension BlockCntView {
    private func configureContentView() {
        addSubviews([titleLabel, blockCnt])
        backgroundColor = .gray50
        layer.cornerRadius = 8
    }
}

// MARK: - Layout

extension BlockCntView {
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        blockCnt.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
