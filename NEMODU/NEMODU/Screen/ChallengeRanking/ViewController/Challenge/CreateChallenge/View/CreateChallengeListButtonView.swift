//
//  CreateChallengeListButtonView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/24.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class CreateChallengeListButtonView: BaseView {
    
    // MARK: - UI components
    
    let titleLabel = UILabel()
        .then {
            $0.font = .body1
            $0.textColor = .gray900
            
            $0.backgroundColor = .clear
        }
    
    let dateLabel = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray600
            
            $0.isHidden = true
        }
    
    var statusImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "add")
            $0.backgroundColor = .clear
        }
    
    lazy var actionButton = UIButton()
        .then {
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
        
        self.backgroundColor = .white
    }
    
    override func layoutView() {
        super.layoutView()
        
        addSubviews([titleLabel, dateLabel, statusImageView])
        addSubview(actionButton)
        
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(56)
            
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(statusImageView.snp.left).inset(-4)
        }
        
        statusImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            
            $0.centerY.equalTo(titleLabel)
            $0.right.equalTo(titleLabel.snp.right)
        }
        
        actionButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
