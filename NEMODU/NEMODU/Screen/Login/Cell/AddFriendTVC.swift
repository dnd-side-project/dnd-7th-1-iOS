//
//  AddFriendTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/12.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AddFriendTVC: BaseTableViewCell {
    private let profileImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFill
        }
    
    private let nameStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 2
        }
    
    private let nickname = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    private let name = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    let addFriendBtn = UIButton()
        .then {
            $0.layer.cornerRadius = 8
            $0.setBackgroundColor(.main, for: .normal)
            $0.setBackgroundColor(.gray100, for: .selected)
            $0.setImage(UIImage(named: "addFriend"), for: .normal)
            $0.setImage(UIImage(named: "addedFriend"), for: .selected)
        }
    
    override func configureView() {
        selectionStyle = .none
        
        addSubviews([profileImageView,
                     nameStackView,
                     addFriendBtn])
        
        [nickname, name].forEach {
            nameStackView.addArrangedSubview($0)
        }
    }
    
    override func layoutSubviews() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        addFriendBtn.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(nameStackView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(56)
            $0.height.equalTo(40)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nickname.text = nil
        name.text = nil
        addFriendBtn.isSelected = false
    }
}

// MARK: - Configure

extension AddFriendTVC {
    // TODO: - 서버 구현 후 수정
//    func configureCell(userInfo: UserInfo) {
//        profileImageView.image = userInfo.profileImage
//        nickname.text = userInfo.nickname
//        name.text = userInfo.name
//    }
}
