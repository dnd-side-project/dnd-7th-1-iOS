//
//  FriendCellProfileView.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/14.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class FriendCellProfileView: BaseView {
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
    
    private let nicknameLabel = UILabel()
        .then {
            $0.text = "-"
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    private lazy var kakaoNameLabel = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
}

// MARK: - Configure

extension FriendCellProfileView {
    private func configureContentView() {
        addSubviews([profileImageView,
                     nameStackView])
        
        nameStackView.addArrangedSubview(nicknameLabel)
    }
    
    /// cell의 prepareForReuse에서 호출
    func prepareForReuse() {
        profileImageView.image = .defaultThumbnail
        nicknameLabel.text = "-"
        kakaoNameLabel.text = nil
    }
    
    /// 뷰의 데이터를 초기화하는 메서드
    func setProfile(_ friendInfo: FriendDefaultInfo) {
        if let picturePathURL = friendInfo.picturePathURL {
            profileImageView.kf.setImage(with: picturePathURL)
        }
        nicknameLabel.text = friendInfo.nickname
    }
    
    // 카카오 추천 친구 프로필을 초기화하는 메서드
    func setKakaoProfile(_ friendInfo: KakaoFriendInfo) {
        nameStackView.addArrangedSubview(kakaoNameLabel)
        if let picturePathURL = friendInfo.picturePathURL {
            profileImageView.kf.setImage(with: picturePathURL)
        }
        nicknameLabel.text = friendInfo.kakaoNickname
        kakaoNameLabel.text = friendInfo.nickname
    }
    
    /// 닉네임을 반환하는 메서드
    func getNickname() -> String? {
        return nicknameLabel.text
    }
}

// MARK: - Layout

extension FriendCellProfileView {
    private func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        nameStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
    }
}
