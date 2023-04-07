//
//  FriendListView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/09/08.
//

import UIKit
import Then
import SnapKit

class FriendListView: BaseView {
    
    // MARK: - UI components
    
    private let containerView = UIView()
    let profileImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.layer.cornerRadius = 36
            $0.layer.masksToBounds = true
        }
    lazy var cancelButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .secondary
            $0.backgroundColor = .white
            
            $0.layer.cornerRadius = 10
        }
    let nicknameLabel = PaddingLabel()
        .then {
            $0.text = "nickname"
            $0.font = .body4
            $0.textColor = .gray900
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
    func configureFriendsListView(friendInfo: Info) {
        nicknameLabel.text = friendInfo.nickname
        profileImageView.kf.setImage(with: friendInfo.picturePathURL, placeholder: UIImage.defaultThumbnail)
    }
    
}

// MARK: - Layout

extension FriendListView {
    
    private func configureLayout() {
        addSubview(containerView)
        containerView.addSubviews([profileImageView, cancelButton, nicknameLabel])
        
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(profileImageView.layer.cornerRadius * 2)

            $0.centerX.equalTo(containerView)
            $0.top.equalTo(containerView.snp.top)
            $0.horizontalEdges.equalTo(containerView)
        }
        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(cancelButton.layer.cornerRadius * 2)
            
            $0.top.right.equalTo(profileImageView)
        }
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalTo(profileImageView)

            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
}
