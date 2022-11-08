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
        challengeTypeLabel.text = "주간" // TODO: - 서버 response 값으로 주간, 실시간 표시 필요
        
        let startDate = waitChallengeListElement.started.split(separator: "-")
        let endDate = waitChallengeListElement.ended.split(separator: "-")
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        let dayOfWeekDate = format.date(from: waitChallengeListElement.started)
        let dayOfWeekString = dayOfWeekDate?.getDayOfWeek()
        
        challengeTermLabel.text = "\(startDate[1]).\(startDate[2])(\(dayOfWeekString ?? "?") - \(endDate[1]). \(endDate[2])(일)"
        
        //        dDayLabel.text =  TODO: - dDay 표시
        
        challengeNameImage.tintColor = ChallengeColorType(rawValue: waitChallengeListElement.color)?.primaryColor
        challengeNameLabel.text = waitChallengeListElement.name
        
        let readyCount = waitChallengeListElement.readyCount
        let totalCount = waitChallengeListElement.totalCount
        currentStateLabel.text = readyCount == totalCount ? "모집완료" : "대기중"
        currentJoinUserLabel.text = "\(readyCount)/\(totalCount)"
        
        makeUserImageViews(numberOfUsers: readyCount, usersImageURL: waitChallengeListElement.picturePaths)
    }
    
}
