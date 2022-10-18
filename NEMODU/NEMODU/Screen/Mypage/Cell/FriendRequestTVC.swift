//
//  FriendRequestTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import Then
import SnapKit

class FriendRequestTVC: BaseTableViewCell {
    private let profileImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "defaultThumbnail")
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
    
    private let nicknameLabel = UILabel()
        .then {
            $0.text = "-"
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    private let acceptBtn = UIButton()
        .then {
            $0.titleLabel?.font = .body2
            $0.setTitle("수락", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundColor(.main, for: .normal)
            $0.layer.cornerRadius = 8
        }
    
    private let refuseBtn = UIButton()
        .then {
            $0.titleLabel?.font = .body2
            $0.setTitle("거절", for: .normal)
            $0.setTitleColor(.gray700, for: .normal)
            $0.setBackgroundColor(.gray100, for: .normal)
            $0.layer.cornerRadius = 8
        }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "defaultThumbnail")
        nicknameLabel.text = nil
    }
}

// MARK: - Configure

extension FriendRequestTVC {
    private func configureContentView() {
        backgroundColor = .systemBackground
        selectionStyle = .none
        addSubviews([profileImageView,
                     nicknameLabel,
                     acceptBtn,
                     refuseBtn])
    }
    
    func configureCell() {
        // TODO: - 서버 구현 후 연결
        nicknameLabel.text = "nickname"
    }
}

// MARK: - Layout

extension FriendRequestTVC {
    private func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        acceptBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
        
        refuseBtn.snp.makeConstraints {
            $0.trailing.equalTo(acceptBtn.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
    }
}
