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
            $0.layer.cornerRadius = 8
        }
    
    let challengeTitle = UILabel()
        .then {
            $0.font = .headline1
            $0.textColor = .gray900
        }
    
    let rank = UILabel()
        .then {
            $0.font = .caption2M
            $0.textColor = .gray500
        }
    
    let arrow = UIImageView()
        .then {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .gray300
        }
    
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
        challengeIcon.image = nil
        challengeTitle.text = nil
        rank.text = nil
    }
}

// MARK: - Configure

extension ProceedingChallengeTVC {
    private func configureView() {
        addSubviews([challengeIcon, challengeTitle, rank, arrow])
    }
    
    private func configureLayout() {
        challengeIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(16)
        }
        
        challengeTitle.snp.makeConstraints {
            $0.top.equalTo(challengeIcon)
            $0.leading.equalTo(challengeIcon.snp.trailing).offset(8)
            $0.trailing.equalTo(arrow.snp.leading)
        }
        
        rank.snp.makeConstraints {
            $0.top.equalTo(challengeTitle.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(challengeTitle)
        }
        
        arrow.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.height.equalTo(14)
            $0.width.equalTo(8)
        }
    }
    
    // TODO: - 서버 연결 후 수정
    func configureCell() {
        challengeIcon.image = UIImage(systemName: "person.circle")
        challengeTitle.text = "챌린지 이름"
        rank.text = "현재 내 순위: 1위"
    }
}
