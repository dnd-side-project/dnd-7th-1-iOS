//
//  ChallengeWaitingTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/19.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeWaitingTVC : ChallengeListTVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Function
}

// MARK: - Configure

extension ChallengeWaitingTVC {
    
    func configureChallengeWaitTVC(waitChallengeListElement: WaitChallengeListElement) {
        // 공통 요소 설정
        configureChallengeListTVC(startDate: waitChallengeListElement.started, endDate: waitChallengeListElement.ended, challengeName: waitChallengeListElement.name, challengeColor: waitChallengeListElement.color, userProfileImagePaths: waitChallengeListElement.picturePaths)
        
        // D-day 계산
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = DateType.hyphen.dateFormatter

        let startDate = dateFormatter.date(from: String(waitChallengeListElement.started.split(separator: "T")[0])) ?? .now
        let components = Calendar.current.dateComponents([.day], from: .now, to: startDate)
        
        

        dDayLabel.text = "D-\(components.day ?? 0)"
        
        // 상태 메세지 표시
        let readyCount = waitChallengeListElement.readyCount
        let totalCount = waitChallengeListElement.totalCount
        currentStateLabel.text = readyCount == totalCount ? "모집완료" : "대기중"
        currentJoinUserLabel.text = "\(readyCount)/\(totalCount)"
    }
    
}
