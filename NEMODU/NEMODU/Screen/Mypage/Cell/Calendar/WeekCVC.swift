//
//  WeekCVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/13.
//

import UIKit
import SnapKit
import Then

class WeekCVC: BaseCollectionViewCell {
    private let weekLabel = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray500
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

extension WeekCVC {
    private func configureContentView() {
        contentView.addSubview(weekLabel)
    }
    
    func configureCell(_ day: String) {
        weekLabel.text = day
        weekLabel.textColor = .gray500
    }
}

// MARK: - Layout

extension WeekCVC {
    func configureLayout() {
        weekLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func selectCell() {
        weekLabel.textColor = .white
    }
}
