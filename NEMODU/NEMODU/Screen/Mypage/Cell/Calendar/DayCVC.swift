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
    
    var date: Date?
    
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
        contentView.backgroundColor = .white
    }
    
    override var isSelected: Bool {
        willSet {
            dayLabel.font = newValue ? .headline1 : .body1
            dayLabel.textColor = newValue ? .white : .gray800
            eventDot.backgroundColor = newValue ? .white : .main
            contentView.backgroundColor = newValue ? .main : .white
        }
    }
}

// MARK: - Configure

extension DayCVC {
    private func configureContentView() {
        contentView.addSubviews([dayLabel, eventDot])
        contentView.layer.cornerRadius = frame.width / 2
    }
    
    func configureCell(date: Date, isEvent: Bool) {
        self.date = date
        dayLabel.text = "\(date.get(.day))"
        eventDot.isHidden = !isEvent
        eventDot.backgroundColor = isSelected ? .white : .main
    }
    
    func setOtherMonthDate() {
        dayLabel.textColor = .gray300
        eventDot.isHidden = true
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
