//
//  CalendarSelectStackView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/23.
//

import UIKit

class CalendarSelectStackView: BaseView {
    private let stackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
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
extension CalendarSelectStackView {
    private func configureContentView() {
        addSubview(stackView)
        for _ in 0...6 {
            let view = UIView()
            view.backgroundColor = .clear
            stackView.addArrangedSubview(view)
        }
    }
    
    func setSelectDay(dayIndex: Int) {
        guard let myRecordDataVC = findViewController() as? BaseViewController else { return }
        
        for i in 0...6 {
            stackView.arrangedSubviews[i].backgroundColor
            = i == dayIndex
            ? .gray100 : .clear
            
            stackView.arrangedSubviews[i].layer.cornerRadius = (myRecordDataVC.screenWidth - 20) / 14
        }
    }
}

// MARK: - Layout

extension CalendarSelectStackView {
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
