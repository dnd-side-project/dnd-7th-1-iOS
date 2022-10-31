//
//  ChallengeListTVHV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/15.
//

import UIKit
import SnapKit

class ChallengeListTVHV : ChallengeTitleTVHV {
    
    // MARK: - UI components
    
    let spaceView = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    let challengeListTypeMenuBar = ChallengeListTypeMenuBarCV()
        .then {
            $0.menuList = ["진행 대기중", "진행 중", "진행 완료"]
        }
    
    // MARK: - Variables and Properties
    
    var challengeContainerCVC: ChallengeVC?
    
    // MARK: - Life Cycle
    
    // MARK: - Function
    
    override func configureHV() {
        super.configureHV()
        
        challengeTitleLabel.text = "챌린지 내역"
    }
    
    override func layoutView() {
        super.layoutView()
        
        contentView.addSubview(spaceView)
        contentView.addSubview(challengeListTypeMenuBar)
        
        
        spaceView.snp.makeConstraints {
            $0.height.equalTo(8)
            
            $0.top.equalTo(contentView.snp.top)
            $0.horizontalEdges.equalTo(contentView)
        }
        containerView.snp.remakeConstraints {
            $0.height.equalTo(containerViewHeight)
            
            $0.top.equalTo(spaceView.snp.bottom)
            $0.horizontalEdges.equalTo(spaceView)
        }
        
        challengeListTypeMenuBar.snp.makeConstraints {
            $0.height.equalTo(64)

            $0.top.equalTo(containerView.snp.bottom)
            $0.horizontalEdges.equalTo(containerView)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
    
}
