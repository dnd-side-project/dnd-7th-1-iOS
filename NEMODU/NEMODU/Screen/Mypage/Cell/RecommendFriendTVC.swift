//
//  RecommendFriendTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import Then
import SnapKit

class RecommendFriendTVC: BaseTableViewCell {
    private let profileImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
    
    private let nameStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 2
        }
    
    private let nicknameLabel = UILabel()
        .then {
            $0.text = "asdfasdf"
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    private let nameLabel = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    private let addFriendBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "friendAdd"), for: .normal)
            $0.setImage(UIImage(named: "friendAdded"), for: .selected)
            $0.setBackgroundColor(.main, for: .normal)
            $0.setBackgroundColor(.gray100, for: .selected)
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
        profileImageView.image = .defaultThumbnail
        nicknameLabel.text = nil
    }
}

// MARK: - Configure

extension RecommendFriendTVC {
    private func configureContentView() {
        backgroundColor = .systemBackground
        selectionStyle = .none
        addSubviews([profileImageView,
                     nameStackView,
                     addFriendBtn])
        [nicknameLabel, nameLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
    }
    
    func configureCell(_ name: String = "") {
        // TODO: - 서버 구현 후 연결
        nicknameLabel.text = "nickname"
        nameLabel.text = name
    }
}

// MARK: - Layout

extension RecommendFriendTVC {
    private func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        nameStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(addFriendBtn.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        addFriendBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
    }
}
