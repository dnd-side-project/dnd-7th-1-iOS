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
        
        let startDates = waitChallengeListElement.started.split(separator: "-")
        let endDates = waitChallengeListElement.ended.split(separator: "-")
        
        let format = DateFormatter()
        format.timeZone = TimeZone(identifier: "KST")
        format.dateFormat = "yyyy-MM-dd"
        
        let dayOfWeekDate = format.date(from: waitChallengeListElement.started)
        let dayOfWeekString = dayOfWeekDate?.getDayOfWeek()
        
        challengeTermLabel.text = "\(startDates[1]).\(startDates[2])(\(dayOfWeekString ?? "?")) - \(endDates[1]). \(endDates[2])(일)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = DateType.hyphen.dateFormatter
        
        let startDate = dateFormatter.date(from: waitChallengeListElement.started) ?? .now
        let components = Calendar.current.dateComponents([.day], from: .now, to: startDate)
        dDayLabel.text = "D-\(components.day ?? 0)"
        
        challengeNameImage.tintColor = ChallengeColorType(rawValue: waitChallengeListElement.color)?.primaryColor
        challengeNameLabel.text = waitChallengeListElement.name
        
        let readyCount = waitChallengeListElement.readyCount
        let totalCount = waitChallengeListElement.totalCount
        currentStateLabel.text = readyCount == totalCount ? "모집완료" : "대기중"
        currentJoinUserLabel.text = "\(readyCount)/\(totalCount)"
        
        makeUserImageViews(numberOfUsers: waitChallengeListElement.picturePaths.count, usersImageURL: waitChallengeListElement.picturePaths)
    }
    
}
