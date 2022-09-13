//
//  DayCVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/13.
//

import UIKit
import SnapKit
import Then

class DayCVC: BaseCollectionViewCell {
    private let dayLabel = UILabel()
        .then {
            $0.font = .body1
            $0.textColor = .gray800
        }
    
    private let eventDot = UIImageView()
        .then {
            $0.isHidden = true
            $0.layer.cornerRadius = 3
        }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        eventDot.isHidden = true
        contentView.backgroundColor = nil
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                dayLabel.font = .headline1
                dayLabel.textColor = .white
                eventDot.backgroundColor = .white
                contentView.backgroundColor = .main
            } else {
                dayLabel.font = .body1
                dayLabel.textColor = .gray800
                eventDot.backgroundColor = .main
                contentView.backgroundColor = nil
            }
        }
    }
}

// MARK: - Configure

extension DayCVC {
    private func configureContentView() {
        contentView.addSubviews([dayLabel, eventDot])
        contentView.layer.cornerRadius = frame.width / 2
    }
    
    func configureCell(_ date: String) {
        dayLabel.text = date
        eventDot.isHidden = false
    }
}

// MARK: - Layout

extension DayCVC {
    private func configureLayout() {
        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        eventDot.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dayLabel.snp.bottom)
            $0.width.height.equalTo(6)
        }
    }
}
