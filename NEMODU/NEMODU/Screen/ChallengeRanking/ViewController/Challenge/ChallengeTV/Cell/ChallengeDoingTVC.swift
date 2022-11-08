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
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Function
    
}

// MARK: - Configure

extension ChallengeDoingTVC {
    
    private func configureContentView() {
        _ = challengeNameImage
            .then {
                $0.image = UIImage(named: "badge_flag")?.withRenderingMode(.alwaysTemplate)
                $0.tintColor = ChallengeColorType(rawValue: "Yellow")?.primaryColor
            }
        
        _ = currentStateLabel
            .then {
                $0.text = "현재 순위: -위"
            }
        _ = currentJoinUserLabel
            .then {
                $0.text = "-/-"
            }
    }
    
    func configureChallengeDoingTVC(progressChallengeListElement: ProgressAndDoneChallengeListElement) {
        challengeTypeLabel.text = "주간" // TODO: - 서버 response 값으로 주간, 실시간 표시 필요
        
        let startDate = progressChallengeListElement.started.split(separator: "-")
        let endDate = progressChallengeListElement.ended.split(separator: "-")
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        let dayOfWeekDate = format.date(from: progressChallengeListElement.started)
        let dayOfWeekString = dayOfWeekDate?.getDayOfWeek()
        
        challengeTermLabel.text = "\(startDate[1]).\(startDate[2])(\(dayOfWeekString ?? "?") - \(endDate[1]). \(endDate[2])(일)"
        
        //        dDayLabel.text =  TODO: - dDay 표시
        
        challengeNameImage.tintColor = ChallengeColorType(rawValue: progressChallengeListElement.color)?.primaryColor
        challengeNameLabel.text = progressChallengeListElement.name
        
        currentStateLabel.text = "현재순위"
        currentJoinUserLabel.text = "\(progressChallengeListElement.rank)위"
        
        makeUserImageViews(numberOfUsers: progressChallengeListElement.picturePaths.count, usersImageURL: progressChallengeListElement.picturePaths)
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
