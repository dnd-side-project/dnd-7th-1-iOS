//
//  SelectFriendsTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/26.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SelectFriendsTVC : BaseTableViewCell {
    
    // MARK: - UI components
    
    let userProfileImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
    
    let userNicknameLabel = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    let checkImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "uncheck")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray300
        }
        
    // MARK: - Variables and Properties
    
    var isSelectCheck: Bool = false
    
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
    
    func didTapCheck() {
        isSelectCheck.toggle()
        checkImageView.image = UIImage(named: isSelectCheck ? "checkCircle" : "uncheck")?.withRenderingMode(.alwaysTemplate)
        checkImageView.tintColor = isSelectCheck ? .secondary : .gray300
    }
    
}

// MARK: - Configure

extension SelectFriendsTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
    func configureSelectFriendsTVC(friendInfo: FriendDefaultInfo) {
        userNicknameLabel.text = friendInfo.nickname
        userProfileImageView.kf.setImage(with: URL(string: friendInfo.picturePath))
        if userProfileImageView.image == nil {
            userProfileImageView.image = .defaultThumbnail
        }
    }
    
}

// MARK: - Layout

extension SelectFriendsTVC {
    
    private func configureLayout() {
        contentView.addSubviews([userProfileImageView, userNicknameLabel, checkImageView])
        
        
        userProfileImageView.snp.makeConstraints {
            $0.width.height.equalTo(userProfileImageView.layer.cornerRadius * 2)
            
            $0.centerY.equalTo(contentView)
            $0.left.equalTo(contentView.snp.left).offset(16)
        }
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.left.equalTo(userProfileImageView.snp.right).offset(16)
        }
        checkImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            
            $0.centerY.equalTo(contentView)
            $0.right.equalTo(contentView.snp.right).inset(16)
        }
    }
    
}
