//
//  SelectChallengeTypeButtonView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/21.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SelectChallengeTypeButtonView: BaseView {
    
    // MARK: - UI components
    
    let challengeTypeView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.addShadow()
            
            $0.layer.cornerRadius = 16
    }
    
    let iconImageView = UIImageView()
        .then {
            $0.tintColor = .gray300
        }
    let titleLabel = UILabel()
        .then {
            $0.font = .title3SB
            $0.textColor = .gray800
            $0.textAlignment = .center
        }
    
    let explainTextView = UITextView()
        .then {
            $0.font = .caption1
            $0.textColor = .gray500
            $0.textAlignment = .center
            $0.backgroundColor = .clear
        }
    
    
    lazy var button = UIButton()
        .then {
            $0.backgroundColor = .clear
            
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = challengeTypeView.layer.cornerRadius
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        addSubviews([challengeTypeView,
                     iconImageView, titleLabel, explainTextView,
                     button])
        
        
        challengeTypeView.snp.makeConstraints {
            $0.width.equalTo(165.5)
            $0.height.equalTo(218)
            
            $0.edges.equalTo(self)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(56)
            
            $0.centerX.equalTo(challengeTypeView)
            $0.top.equalTo(challengeTypeView.snp.top).offset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(iconImageView)
            
            $0.top.equalTo(iconImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(challengeTypeView).offset(10).inset(10)
        }
        explainTextView.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel)
            
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.bottom.equalTo(challengeTypeView.snp.bottom).inset(4)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalTo(challengeTypeView)
        }
    }
    
    // MARK: - Functions
}
