//
//  InvitedFriendsTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/01.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class InvitedFriendsTVC : BaseTableViewCell {
    
    // MARK: - UI components
    
    private let userProfileImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "defaultThumbnail")
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
    private let showMeLabel = UILabel()
        .then {
            $0.text = "나"
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = .PretendardRegular(size: 10)
            
            $0.backgroundColor = .secondary
            
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            $0.isHidden = true
        }
    
    private let userNicknameLabel = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray900
            $0.text = "---"
        }
    
    private let friendStatusLabel = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray600
            $0.text = "----"
        }
        
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        markMe(isMe: false)
    }
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayoutView()
    }
    
    // MARK: - Function
    
    func configureInvitedFriendsTVC(userProfileImage: String, nickname: String, isAccept: Bool) {
        userNicknameLabel.text = nickname
        
        if(nickname == UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)) {
            markMe(isMe: true)
        }
        
        switch isAccept {
        case true:
            _ = friendStatusLabel
                .then {
                    $0.textColor = .main
                    $0.text = "수락 완료"
                }
        case false:
            _ = friendStatusLabel
                .then {
                    $0.textColor = .gray600
                    $0.text = "대기중"
                }
        }
    }
    
    private func markMe(isMe: Bool) {
        showMeLabel.isHidden = isMe ? false : true
    }
    
}

// MARK: - Configure

extension InvitedFriendsTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension InvitedFriendsTVC {
    
    private func configureLayoutView() {
        super.layoutView()
        
        contentView.addSubviews([userProfileImageView, showMeLabel,
                                 userNicknameLabel,
                                 friendStatusLabel])
        
        
        userProfileImageView.snp.makeConstraints {
            $0.width.height.equalTo(userProfileImageView.layer.cornerRadius * 2)
            
            $0.centerY.equalTo(contentView)
            $0.left.equalTo(contentView.snp.left).offset(16)
        }
        showMeLabel.snp.makeConstraints {
            $0.width.height.equalTo(16)
            
            $0.right.equalTo(userProfileImageView.snp.right)
            $0.bottom.equalTo(userProfileImageView.snp.bottom)
        }

        
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.left.equalTo(userProfileImageView.snp.right).offset(16)
        }
        
        friendStatusLabel.snp.makeConstraints {
//            $0.width.height.equalTo(24)
            
            $0.centerY.equalTo(contentView)
            $0.right.equalTo(contentView.snp.right).inset(13)
        }
    }
    
}

