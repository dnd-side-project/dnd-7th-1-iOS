//
//  FriendListTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import Then
import SnapKit

class FriendListDefaultTVC: BaseTableViewCell {
    private let profileImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
    
    private let nicknameLabel = UILabel()
        .then {
            $0.text = "-"
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    private let deleteBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "dismiss")?.withTintColor(.gray500),
                        for: .normal)
            $0.isHidden = true
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

extension FriendListDefaultTVC {
    private func configureContentView() {
        backgroundColor = .systemBackground
        selectionStyle = .none
        addSubviews([profileImageView,
                     nicknameLabel,
                     deleteBtn])
    }
    
    func configureCell(isEdit: Bool) {
        // TODO: - 서버 구현 후 연결
        nicknameLabel.text = "nickname"
        deleteBtn.isHidden = !isEdit
    }
}

// MARK: - Layout

extension FriendListDefaultTVC {
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
        
        deleteBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
}
