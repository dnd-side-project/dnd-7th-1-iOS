//
//  ChallengeTermButtonView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/25.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeTermButtonView: CreateChallengeListButtonView {
    
    // MARK: - UI components
    
    let settingLabel = UILabel()
        .then {
            $0.text = "설정"
            $0.font = .body3
            $0.textColor = .gray400
            
            $0.backgroundColor = .clear
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        statusImageView.snp.removeConstraints()
        statusImageView.removeFromSuperview()
        
        addSubview(settingLabel)
        settingLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalTo(titleLabel.snp.right)
        }
        
    }
    
}
