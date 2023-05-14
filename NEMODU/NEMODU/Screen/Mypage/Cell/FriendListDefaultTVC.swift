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
    private let friendProfileView = FriendCellProfileView()
    
    private let deleteFriendBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "dismiss")?.withTintColor(.gray500),
                        for: .normal)
            $0.isHidden = true
        }
    
    override func configureView() {
        super.configureView()
        
        addSubviews([friendProfileView,
                     deleteFriendBtn])
    }
    
    override func layoutView() {
        super.layoutView()
        
        friendProfileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(deleteFriendBtn.snp.leading).offset(-16)
        }
        
        deleteFriendBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendProfileView.prepareForReuse()
    }
}

// MARK: - Configure

extension FriendListDefaultTVC {
    func configureCell(_ friendInfo: FriendsInfo, isEditing: Bool) {
        friendProfileView.setProfile(friendInfo)
        deleteFriendBtn.isHidden = !isEditing
    }
}
