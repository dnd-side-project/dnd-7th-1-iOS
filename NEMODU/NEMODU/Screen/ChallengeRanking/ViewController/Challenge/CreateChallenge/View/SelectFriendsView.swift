//
//  SelectFriendsView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/05/06.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SelectFriendsView : BaseView {
    
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
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureSelectFriendsView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Function
    
}

// MARK: - Configure

extension SelectFriendsView {
    
    private func configureSelectFriendsView() {
        backgroundColor = .white
    }
    
    /// SelectFriendsView 내부 컴포넌트 표시 값 초기화 함수
    func configureSelectFriendsView(friendInfo: Info) {
        userNicknameLabel.text = friendInfo.nickname
        userProfileImageView.kf.setImage(with: URL(string: friendInfo.picturePath))
        if userProfileImageView.image == nil {
            userProfileImageView.image = .defaultThumbnail
        }
    }
    
}

// MARK: - Layout

extension SelectFriendsView {
    
    private func configureLayout() {
        addSubviews([userProfileImageView, userNicknameLabel, checkImageView])
        
        self.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.width.height.equalTo(userProfileImageView.layer.cornerRadius * 2)
            
            $0.centerY.equalTo(self)
            $0.left.equalTo(self.snp.left).offset(16)
        }
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.left.equalTo(userProfileImageView.snp.right).offset(16)
        }
        checkImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            
            $0.centerY.equalTo(self)
            $0.right.equalTo(self.snp.right).inset(16)
        }
    }
    
}
