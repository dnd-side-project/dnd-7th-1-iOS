//
//  OnboardingView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/20.
//

import UIKit
import SnapKit
import Then

class OnboardingView: BaseView {
    let title = UILabel()
        .then {
            $0.font = .PretendardExtraBold(size: 28)
            $0.textColor = .gray900
        }
    
    let message = UILabel()
        .then {
            $0.font = .title2
            $0.textColor = .gray900
            $0.setLineBreakMode()
        }
    
    let line = UIView()
        .then {
            $0.backgroundColor = .main
            $0.layer.cornerRadius = 1
        }
    
    let emphasis = UIImageView(image: UIImage(named: "emphasis"))
    
    let star = UIImageView(image: UIImage(named: "star"))
    
    let baseImageView = UIImageView()
    
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

extension OnboardingView {
    private func configureContentView() {
        addSubviews([baseImageView, title, message, line, emphasis, star])
    }
}

// MARK: - Layout

extension OnboardingView {
    private func configureLayout() {
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(105)
            $0.leading.equalToSuperview().offset(25)
        }
        
        message.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(35)
            $0.leading.equalToSuperview().offset(24)
        }
        
        line.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(title.snp.width)
            $0.height.equalTo(2)
        }
        
        emphasis.snp.makeConstraints {
            $0.top.equalTo(title.snp.top).offset(-8)
        }
        
        star.snp.makeConstraints {
            $0.top.equalTo(emphasis.snp.top)
            $0.leading.equalTo(emphasis.snp.trailing)
            $0.width.height.equalTo(16)
        }
    }
}
