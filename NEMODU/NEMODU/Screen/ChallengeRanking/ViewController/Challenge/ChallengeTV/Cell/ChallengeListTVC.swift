//
//  ChallengeListTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/16.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeListTVC : BaseTableViewCell {
    
    // MARK: - UI components
    
    private let contentsView = UIView()
        .then {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            
            $0.layer.borderColor = UIColor.gray100.cgColor
            $0.layer.borderWidth = 1
        }
    
    private let innerContentsView = UIView()
    
    private let challengeTypeLabel = UILabel()
        .then {
            $0.text = "종류"
            $0.font = .caption1
            $0.textColor = .main
            $0.backgroundColor = .clear
            $0.textAlignment = .center
            
            $0.layer.cornerRadius = 11
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.main.cgColor
        }
    private let challengeTermLabel = UILabel()
        .then {
            $0.text = "00.00(-) - 00.00(-)"
            $0.font = .body4
            $0.textColor = .gray600
        }
    let dDayLabel = UILabel()
        .then {
            $0.text = "D-"
            $0.font = .body4
            $0.textColor = .gray600
        }
    
    private let challengeNameImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "badge_flag")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = ChallengeColorType.pink.primaryColor
        }
    private let challengeNameLabel = UILabel()
        .then {
            $0.text = "챌린지 이름"
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    let currentStateLabel = UILabel()
        .then {
            $0.text = "----"
            $0.font = .caption1
            $0.textColor = .gray600
        }
    let currentJoinUserLabel = UILabel()
        .then {
            $0.text = "-/-"
            $0.font = .caption1
            $0.textColor = .gray900
        }
        
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
    
    /// 챌린지 목록 TVC 내 구성 요소 중 공통 항목을 설정하는 함수
    func configureChallengeListTVC(startDate: String, endDate: String, challengeName: String, challengeColor: String, userProfileImagePaths: [String]) {
        challengeTypeLabel.text = "주간" // TODO: - 서버 response 값으로 주간, 실시간 표시 필요
        
        // 날짜
        let startDates: Date? = startDate.toDate(.withTime)
        let endDates: Date? = endDate.toDate(.withTime)
        
        let format = DateFormatter()
        format.timeZone = TimeZone(identifier: "KST")
        format.dateFormat = DateType.hyphen.dateFormatter
        
        let dayOfWeekDate: Date? = format.date(from: String(startDate.split(separator: "T")[0]))
        let dayOfWeekString: String? = dayOfWeekDate?.getDayOfWeek()
        
        if let startDates, let endDates, let dayOfWeekString {
            challengeTermLabel.text = "\(startDates.month.showTwoDigitNumber).\(startDates.day.showTwoDigitNumber)(\(dayOfWeekString)) - \(endDates.month.showTwoDigitNumber).\(endDates.day.showTwoDigitNumber)(일)"
        }
        
        // 챌린지 아이콘 색상 설정
        challengeNameImageView.tintColor = ChallengeColorType(rawValue: challengeColor)?.primaryColor
        
        // 챌린지 이름 설정
        challengeNameLabel.text = challengeName
        
        // 참가 사용자 프로필 이미지 구성
        makeUserImageViews(numberOfUsers: userProfileImagePaths.count, usersImageURL: userProfileImagePaths)
    }
    
    /// 챌린지 참가 사용자 프로필 이미지 구성 함수
    private func makeUserImageViews(numberOfUsers: Int, usersImageURL: [String]) {
        let userImageContainerView = UIView()
        
        let spacing = 12
        for order in 0..<numberOfUsers {
            // set userImageView style
            let userImageView = UIImageView()
                .then {
                    $0.layer.cornerRadius = 8
                    $0.layer.masksToBounds = true
                    $0.layer.borderWidth = 1
                    $0.layer.borderColor = UIColor.white.cgColor
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    
                    $0.kf.setImage(with: URL(string: usersImageURL[order]), placeholder: UIImage.defaultThumbnail)
                }
            
            // make userImageViews contraints
            userImageContainerView.addSubview(userImageView)
            
            userImageView.snp.makeConstraints {
                $0.width.equalTo(16)
                $0.height.equalTo(userImageView.snp.width)
                
                $0.verticalEdges.equalTo(userImageContainerView)
                $0.right.equalTo(userImageContainerView.snp.right).inset((numberOfUsers - order) * spacing)
            }
            
            // make userImageViews contraints to contentsView
            innerContentsView.addSubview(userImageContainerView)
            
            userImageContainerView.snp.makeConstraints {
                $0.centerY.equalTo(currentStateLabel)
                $0.right.equalTo(dDayLabel.snp.right)
            }
        }
    }
    
}

// MARK: - Configure

extension ChallengeListTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension ChallengeListTVC {
    
    private func configureLayout() {
        contentView.addSubview(contentsView)
        contentsView.addSubview(innerContentsView)
        innerContentsView.addSubviews([challengeTypeLabel, challengeTermLabel, dDayLabel,
                                       challengeNameImageView, challengeNameLabel,
                                       currentStateLabel, currentJoinUserLabel])
        
        
        let padding1 = 12
        let padding2 = 16
        contentsView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.horizontalEdges.equalTo(contentView).inset(padding2)
            $0.bottom.equalTo(contentView.snp.bottom).inset(padding1)
        }
        
        innerContentsView.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentsView).inset(padding2)
            $0.horizontalEdges.equalTo(contentsView).inset(padding1)
        }
        
        challengeTypeLabel.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(challengeTypeLabel.layer.cornerRadius * 2)
            
            $0.top.equalTo(innerContentsView.snp.top)
            $0.left.equalTo(innerContentsView.snp.left)
        }
        challengeTermLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            
            $0.centerY.equalTo(challengeTypeLabel)
            $0.left.equalTo(challengeTypeLabel.snp.right).offset(4)
            $0.right.greaterThanOrEqualTo(dDayLabel.snp.left).inset(-8)
        }
        dDayLabel.snp.makeConstraints {
            $0.centerY.equalTo(challengeTypeLabel)
            
            $0.right.equalTo(innerContentsView.snp.right)//.inset(12)
        }
        
        challengeNameImageView.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(challengeNameImageView.snp.width)
            
            $0.top.equalTo(challengeTypeLabel.snp.bottom).offset(8)
            $0.left.equalTo(challengeTypeLabel.snp.left)
        }
        challengeNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(challengeNameImageView)
            
            $0.left.equalTo(challengeNameImageView.snp.right).offset(8)
            $0.right.equalTo(dDayLabel.snp.right)
        }
        currentStateLabel.snp.makeConstraints {
            $0.top.equalTo(challengeNameImageView.snp.bottom).offset(9)
            $0.left.equalTo(challengeNameImageView.snp.left)
        }
        currentJoinUserLabel.snp.makeConstraints {
            $0.centerY.equalTo(currentStateLabel)
            $0.left.equalTo(currentStateLabel.snp.right).offset(4)
        }
    }
    
}
