//
//  RefreshBtnView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/11/01.
//

import UIKit
import SnapKit
import Then

class RefreshBtnView: BaseView {
    private let titleLabel = UILabel()
        .then {
            $0.text = "이번 주 기록"
            $0.font = .title2
            $0.textColor = .gray900
        }
    
    private let blocksCnt = UILabel()
        .then {
            $0.text = "현재 나의 영역: -칸"
            $0.font = .headline2
            $0.textColor = .gray800
        }
    
    private let refreshImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "refresh")
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

extension RefreshBtnView {
    private func configureContentView() {
        addSubviews([titleLabel,
                     blocksCnt,
                     refreshImageView])
    }
    
    func configureBlocksCnt(_ cnt: Int) {
        blocksCnt.text = "현재 나의 영역: \(cnt.insertComma)칸"
    }
}

// MARK: - Layout

extension RefreshBtnView {
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalToSuperview().offset(14)
        }
        
        refreshImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-14)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.width.height.equalTo(25)
        }
        
        blocksCnt.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
        }
    }
}
