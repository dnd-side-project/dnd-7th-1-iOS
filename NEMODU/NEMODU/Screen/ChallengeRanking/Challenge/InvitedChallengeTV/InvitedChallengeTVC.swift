//
//  InvitedChallengeTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class InvitedChallengeTVC : BaseTableViewCell {
    
    // MARK: - UI components
    
    let contentsView = UIView()
        .then {
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
    
    let timeStatusButton = UIButton()
        .then {
            $0.setTitle("주간", for: .normal)
            $0.titleLabel?.font = .caption1
            $0.setTitleColor(.main, for: .normal)
            $0.backgroundColor = .clear
            
            $0.layer.cornerRadius = 11
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.main.cgColor
            
            $0.isUserInteractionEnabled = false
        }
    
    let challengeNameLabel = UILabel()
        .then {
            $0.text = "챌린지 이름"
            $0.font = .body3
            $0.textColor = .gray900
        }
    let timeAgoLabel = UILabel()
        .then {
            $0.text = "3분 전"
            $0.font = .caption2R
            $0.textColor = .gray500
        }
    let notYetCheckDetailCircleView = UIView()
        .then {
            $0.backgroundColor = .red100
            $0.layer.cornerRadius = 3
            $0.layer.masksToBounds = true
        }
    
    let userProfileImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "userDefaultProfileImage")
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
    let userNicknameLabel = UILabel()
        .then {
            $0.text = "친구 닉네임"
            $0.font = .body4
            $0.textColor = .gray900
        }
    let invitedMessage = UILabel()
        .then {
            $0.text = "초대 메세지: 같이 ㄱㄱ"
            $0.font = .caption1
            $0.textColor = .gray500
        }
    let seeDetailButton = UIButton()
        .then {
            $0.setTitle("상세보기", for: .normal)
            $0.titleLabel?.font = .caption1
            $0.setTitleColor(.gray700, for: .normal)
            $0.backgroundColor = .gray200
            
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        }
        
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    override func configureView() {
        super.configureView()
        
        selectionStyle = .none
    }
    
    override func layoutView() {
        super.layoutView()
        
        contentView.addSubview(contentsView)
        
        contentsView.addSubview(timeStatusButton)
        contentsView.addSubview(challengeNameLabel)
        contentsView.addSubview(timeAgoLabel)
        contentsView.addSubview(notYetCheckDetailCircleView)
        
        contentsView.addSubview(userProfileImageView)
        contentsView.addSubview(userNicknameLabel)
        contentsView.addSubview(invitedMessage)
        contentsView.addSubview(seeDetailButton)
        
        
        contentsView.snp.makeConstraints {
            let paddingTB = 12
            let paddingLR = 16
            
            $0.top.equalTo(contentView.snp.top).offset(paddingTB)
            $0.left.equalTo(contentView.snp.left).offset(paddingLR)
            $0.right.equalTo(contentView.snp.right).inset(paddingLR)
            $0.bottom.equalTo(contentView.snp.bottom).inset(paddingTB / 2)
        }
        
        timeStatusButton.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(timeStatusButton.layer.cornerRadius * 2)
            
            $0.top.equalTo(contentsView.snp.top).offset(16)
            $0.left.equalTo(contentsView.snp.left).offset(12)
        }
        challengeNameLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            
            $0.centerY.equalTo(timeStatusButton)
            $0.left.equalTo(timeStatusButton.snp.right).offset(8)
            $0.right.equalTo(timeAgoLabel.snp.left).inset(-8)
        }
        timeAgoLabel.snp.makeConstraints {
            $0.height.equalTo(13)

            $0.centerY.equalTo(timeStatusButton)
            $0.right.equalTo(notYetCheckDetailCircleView.snp.left).inset(-4)
        }
        notYetCheckDetailCircleView.snp.makeConstraints {
            $0.height.equalTo(notYetCheckDetailCircleView.layer.cornerRadius * 2)
            $0.width.equalTo(notYetCheckDetailCircleView.snp.height)
            
            $0.top.equalTo(contentsView.snp.top).offset(20.5)
            $0.right.equalTo(contentsView.snp.right).inset(12)
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.height.equalTo(userProfileImageView.layer.cornerRadius * 2)
            $0.width.equalTo(userProfileImageView.snp.height)
            
            $0.top.equalTo(timeStatusButton.snp.bottom).offset(4)
            $0.left.equalTo(timeStatusButton.snp.left)
        }
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.top).offset(3)
            $0.left.equalTo(userProfileImageView.snp.right).offset(8)
            $0.right.equalTo(seeDetailButton.snp.left).inset(-8)
        }
        invitedMessage.snp.makeConstraints {
            $0.top.equalTo(userNicknameLabel.snp.bottom).offset(4)
            $0.left.equalTo(userNicknameLabel.snp.left)
            $0.right.equalTo(seeDetailButton.snp.left).inset(-8)
        }
        seeDetailButton.snp.makeConstraints {
            $0.width.equalTo(66)
            $0.height.equalTo(seeDetailButton.layer.cornerRadius * 2)
            
            $0.centerY.equalTo(userProfileImageView)
            $0.right.equalTo(notYetCheckDetailCircleView.snp.right)
        }
    }
    
}
