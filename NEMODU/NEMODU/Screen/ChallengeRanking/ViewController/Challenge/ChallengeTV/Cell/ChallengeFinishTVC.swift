//
//  ChallengeFinishTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/19.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeFinishTVC : ChallengeListTVC {
    
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

extension ChallengeFinishTVC {
    
    func configureChallengeFinishTVC(doneChallengeListElement: ProgressAndDoneChallengeListElement) {
        // 공통 요소 설정
        configureChallengeListTVC(startDate: doneChallengeListElement.started, endDate: doneChallengeListElement.ended, challengeName: doneChallengeListElement.name, challengeColor: doneChallengeListElement.color, userProfileImagePaths: doneChallengeListElement.picturePaths)
        
        // 현재 상태 메세지 표시
        currentStateLabel.text = "현재순위"
        currentJoinUserLabel.text = "\(doneChallengeListElement.rank)위"
    }
    
}

// MARK: - Layout

extension ChallengeFinishTVC {
    
    private func configureLayout() {
        // remove for hide
        dDayLabel.snp.makeConstraints {
            $0.width.equalTo(0)
        }
    }
    
}
