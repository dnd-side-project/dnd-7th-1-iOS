//
//  ChallengeDetailTVHV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeDetailTVHV : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    let challengeDetailInfoContainerView = UIView()
    private let challengeTypeLabel = UILabel()
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
    
    let challengeNameImage = UIImageView()
        .then {
            $0.image = UIImage(named: "badge_flag")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = ChallengeColorType(rawValue: "Pink")?.primaryColor
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
    
    private let viewModel = InvitedChallengeDetailVM()
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureHV()
        configureLayoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    // MARK: - Configure
    
    func configureHV() {
        contentView.backgroundColor = .white
    }
    
    func configureLayoutView() {
        contentView.addSubviews([challengeDetailInfoContainerView])
        challengeDetailInfoContainerView.addSubviews([challengeTypeLabel, weekChallengeTypeLabel,
                                                      challengeNameImage, challengeNameLabel,
                                                      currentStateLabel])
        
        
        challengeDetailInfoContainerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView)
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

        challengeNameImage.snp.makeConstraints {
            $0.width.height.equalTo(16)

            $0.top.equalTo(challengeTypeLabel.snp.bottom).offset(20).priority(.high)
            $0.left.equalTo(challengeTypeLabel.snp.left)
        }
        challengeNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(challengeNameImage)

            $0.left.equalTo(challengeNameImage.snp.right).offset(8)
            $0.right.equalTo(challengeDetailInfoContainerView.snp.right).inset(16)
        }
        currentStateLabel.snp.makeConstraints {
            $0.top.equalTo(challengeNameImage.snp.bottom).offset(12)
            $0.left.equalTo(challengeNameImage.snp.left)
            $0.right.equalTo(challengeNameLabel.snp.right)
            $0.bottom.equalTo(challengeDetailInfoContainerView.snp.bottom).inset(16)
        }
    }
    
}
