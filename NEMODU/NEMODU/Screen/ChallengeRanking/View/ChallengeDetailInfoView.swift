//
//  ChallengeDetailInfoView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/01/17.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeDetailInfoView: BaseView {
    
    // MARK: - UI components
    
    let challengeDetailInfoContainerView = UIView()
    let challengeTypeLabel = UILabel()
        .then {
            $0.text = "주간"
            $0.font = .caption1
            $0.textColor = .main
            $0.backgroundColor = .clear
            $0.textAlignment = .center
            
            $0.layer.cornerRadius = 11
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.main.cgColor
        }
    let weekChallengeTypeLabel = UILabel()
        .then {
            $0.text = "-----"
            $0.font = .body4
            $0.textColor = .gray600
        }
    
    let challengeNameImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "badge_flag")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = ChallengeColorType.pink.primaryColor
        }
    let challengeNameLabel = UILabel()
        .then {
            $0.text = "-----"
            $0.font = .title3SB
            $0.textColor = .gray900
        }
    let currentStateLabel = UILabel()
        .then {
            $0.text = "---- -월 -주차 (--.--~--.--)"
            $0.font = .body4
            $0.textColor = .gray600
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        backgroundColor = .white
    }
    
    override func layoutView() {
        super.layoutView()
        
        addSubviews([challengeDetailInfoContainerView])
        challengeDetailInfoContainerView.addSubviews([challengeTypeLabel, weekChallengeTypeLabel,
                                                      challengeNameImageView, challengeNameLabel,
                                                      currentStateLabel])
        
        
        challengeDetailInfoContainerView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        challengeTypeLabel.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(challengeTypeLabel.layer.cornerRadius * 2).priority(.high)
            
            $0.top.left.equalTo(challengeDetailInfoContainerView).offset(16)
        }
        weekChallengeTypeLabel.snp.makeConstraints {
            $0.centerY.equalTo(challengeTypeLabel)

            $0.left.equalTo(challengeTypeLabel.snp.right).offset(8)
        }

        challengeNameImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)

            $0.top.equalTo(challengeTypeLabel.snp.bottom).offset(20).priority(.high)
            $0.left.equalTo(challengeTypeLabel.snp.left)
        }
        challengeNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(challengeNameImageView)

            $0.left.equalTo(challengeNameImageView.snp.right).offset(8)
            $0.right.equalTo(challengeDetailInfoContainerView.snp.right).inset(16)
        }
        currentStateLabel.snp.makeConstraints {
            $0.top.equalTo(challengeNameImageView.snp.bottom).offset(12)
            $0.left.equalTo(challengeNameImageView.snp.left)
            $0.right.equalTo(challengeNameLabel.snp.right)
            $0.bottom.equalTo(challengeDetailInfoContainerView.snp.bottom).inset(16)
        }
    }
    
    // MARK: - Functions
}
