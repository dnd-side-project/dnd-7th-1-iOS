//
//  FriendRequestTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import Then
import SnapKit

class FriendRequestHandlingTVC: BaseTableViewCell {
    private let friendProfileView = FriendCellProfileView()
    
    private let acceptFriendBtn = UIButton()
        .then {
            $0.titleLabel?.font = .body2
            $0.setTitle("수락", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundColor(.main, for: .normal)
            $0.layer.cornerRadius = 8
        }
    
    private let refuseFriendBtn = UIButton()
        .then {
            $0.titleLabel?.font = .body2
            $0.setTitle("거절", for: .normal)
            $0.setTitleColor(.gray700, for: .normal)
            $0.setBackgroundColor(.gray100, for: .normal)
            $0.layer.cornerRadius = 8
        }
    
    override func configureView() {
        super.configureView()
        
        selectionStyle = .none
        addSubviews([friendProfileView,
                     acceptFriendBtn,
                     refuseFriendBtn])
    }
    
    override func layoutView() {
        super.layoutView()
        
        friendProfileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(refuseFriendBtn.snp.leading).offset(-16)
        }
        
        refuseFriendBtn.snp.makeConstraints {
            $0.trailing.equalTo(acceptFriendBtn.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }

        acceptFriendBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendProfileView.prepareForReuse()
    }
}

// MARK: - Configure

extension FriendRequestHandlingTVC {
    func configureCell(_ friendInfo: FriendsInfo) {
        friendProfileView.setProfile(friendInfo)
    }
}
