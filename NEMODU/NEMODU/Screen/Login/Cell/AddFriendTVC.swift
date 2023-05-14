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
import Kingfisher

class AddFriendTVC: BaseTableViewCell {
    private let profileImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
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
    
    lazy var addFriendBtn = UIButton()
        .then {
            $0.layer.cornerRadius = 8
            $0.setBackgroundColor(.main, for: .normal)
            $0.setBackgroundColor(.gray100, for: .selected)
            $0.setImage(UIImage(named: "addFriend"), for: .normal)
            $0.setImage(UIImage(named: "addedFriend"), for: .selected)
        }
    
    lazy var deleteFriendBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "dismiss")?.withTintColor(.gray500),
                        for: .normal)
        }
    
    lazy var acceptRequestBtn = UIButton()
        .then {
            $0.layer.cornerRadius = 8
            $0.titleLabel?.font = .body2
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundColor(.main, for: .normal)
            $0.setTitle("수락", for: .normal)
        }
    
    lazy var refuseRequestBtn = UIButton()
        .then {
            $0.layer.cornerRadius = 8
            $0.titleLabel?.font = .body2
            $0.setTitleColor(.gray700, for: .normal)
            $0.setBackgroundColor(.gray100, for: .normal)
            $0.setTitle("거절", for: .normal)
        }
    
    override func configureView() {
        selectionStyle = .none
        
        addSubviews([profileImageView,
                     nameStackView])
        
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = .defaultThumbnail
        nickname.text = nil
        name.text = nil
        addFriendBtn.isSelected = false
    }
}

// MARK: - Configure

extension AddFriendTVC {
    /// 기본 친구 cell을 초기화하는 메서드
    /// isdeleteBtnHidden 상태에 따라 삭제 버튼 추가
    func configureDefaultFriendCell(_ friendInfo: FriendsInfo, isDeleteBtnHidden: Bool = true) {
        if let profileImageURL = friendInfo.profileImageURL {
            profileImageView.kf.setImage(with: profileImageURL)
        }
        nickname.text = friendInfo.nickname
        name.text = friendInfo.kakaoName
        
        if !isDeleteBtnHidden {
            layoutDeleteFriendBtn()
        }
    }

    /// 친구 신청/취소 버튼이 있는 cell
    func configureRequestFriendCell(_ friendInfo: FriendsInfo) {
        configureDefaultFriendCell(friendInfo)

        layoutAddFriendBtn()
        addFriendBtn.isSelected = FriendStatusType(rawValue: friendInfo.status ?? "NO_FRIEND")?.isSelected ?? true
    }
    
    /// 친구 요청 처리 버튼이 있는 cell
    func configureRequestHandlingCell(_ friendInfo: FriendsInfo) {
        configureDefaultFriendCell(friendInfo)
        
        layoutRequestHandlingBtn()
    }
}

// MARK: - Layout

extension AddFriendTVC {
    /// 친구 추가/삭제 버튼을 셀에 추가하고 레이아웃을 지정
    private func layoutAddFriendBtn() {
        addSubview(addFriendBtn)
        addFriendBtn.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(nameStackView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(56)
            $0.height.equalTo(40)
        }
    }
    
    /// 친구 삭제 버튼을 셀에 추가하고 레이아웃을 지정
    private func layoutDeleteFriendBtn() {
        addSubview(deleteFriendBtn)
        deleteFriendBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    /// 친구 요청 처리 버튼(수락/거절)을 셀에 추가하고 레이아웃을 지정
    private func layoutRequestHandlingBtn() {
        addSubviews([acceptRequestBtn, refuseRequestBtn])
        acceptRequestBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
        
        refuseRequestBtn.snp.makeConstraints {
            $0.trailing.equalTo(acceptRequestBtn.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
    }
}
