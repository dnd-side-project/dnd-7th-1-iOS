//
//  ProceedingChallengeTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/08.
//

import UIKit
import SnapKit
import Then

class ProceedingChallengeTVC: UITableViewCell {
    let challengeIcon = UIImageView()
        .then {
            $0.image = UIImage(named: "badge_flag")?.withRenderingMode(.alwaysTemplate)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
        }
    
    let challengeTitle = UILabel()
        .then {
            $0.font = .headline1
            $0.textColor = .gray900
        }
    
    let challengeSubtitle = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    let arrow = UIImageView()
        .then {
            $0.image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray300
        }
    
    var challengeUUID: String?
    var endDate: Date?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        challengeIcon.tintColor = .clear
        challengeTitle.text = nil
        challengeSubtitle.text = nil
        challengeUUID = nil
    }
}

// MARK: - Configure

extension ProceedingChallengeTVC {
    private func configureView() {
        addSubviews([challengeIcon, challengeTitle, challengeSubtitle, arrow])
    }
    
    private func configureLayout() {
        challengeIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(16)
        }
        
        challengeTitle.snp.makeConstraints {
            $0.top.equalTo(challengeIcon).offset(-2)
            $0.leading.equalTo(challengeIcon.snp.trailing).offset(8)
            $0.trailing.equalTo(arrow.snp.leading)
        }
        
        challengeSubtitle.snp.makeConstraints {
            $0.top.equalTo(challengeTitle.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(challengeTitle)
        }
        
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
        }
    }
    
    func configureCell(with element: ChallengeElementResponseModel, isMyList: Bool = false) {
        challengeIcon.tintColor = ChallengeColorType(rawValue: element.color)?.primaryColor ?? .gray500
        challengeTitle.text = element.name
        challengeUUID = element.uuid
        endDate = element.ended.toDate(.hyphen)
        
        if let rank = element.rank {
            challengeSubtitle.text = isMyList
            ? "현재 내 순위: \(rank)위"
            : "현재 순위: \(rank)위"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 dd일"
            let started = dateFormatter.string(from: element.started.toDate(.hyphen))
            
            dateFormatter.dateFormat = "dd일"
            let ended = dateFormatter.string(from: element.ended.toDate(.hyphen))
            
            challengeSubtitle.text = "\(started) ~ \(ended)"
        }
    }
}
