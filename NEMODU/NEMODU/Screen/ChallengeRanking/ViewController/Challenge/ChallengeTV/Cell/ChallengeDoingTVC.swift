//
//  ChallengeDoingTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/19.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeDoingTVC : ChallengeListTVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Function
}

// MARK: - Configure

extension ChallengeDoingTVC {
    
    func configureChallengeDoingTVC(progressChallengeListElement: ProgressAndDoneChallengeListElement) {
        // 공통 요소 설정
        configureChallengeListTVC(startDate: progressChallengeListElement.started, endDate: progressChallengeListElement.ended, challengeName: progressChallengeListElement.name, challengeColor: progressChallengeListElement.color, userProfileImagePaths: progressChallengeListElement.picturePaths)
        
        // 현재 상태 메세지 표시
        currentStateLabel.text = "현재순위"
        currentJoinUserLabel.text = "\(progressChallengeListElement.rank)위"
    }
    
}

// MARK: - Layout

extension ChallengeDoingTVC {
    
    private func configureLayout() {
        // remove for hide
        dDayLabel.snp.makeConstraints {
            $0.width.equalTo(0)
        }
    }
    
}
