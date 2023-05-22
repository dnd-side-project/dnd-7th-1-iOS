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

class FriendAddTVC: BaseTableViewCell {
    private let friendProfileView = FriendCellProfileView()
    
    private let addFriendBtn = UIButton()
        .then {
            $0.layer.cornerRadius = 8
            $0.setBackgroundColor(.main, for: .normal)
            $0.setBackgroundColor(.gray100, for: .selected)
            $0.setImage(UIImage(named: "addFriend"), for: .normal)
            $0.setImage(UIImage(named: "addedFriend"), for: .selected)
        }
    
    override func configureView() {
        super.configureView()
        
        selectionStyle = .none
        addSubviews([friendProfileView,
                     addFriendBtn])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        friendProfileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(addFriendBtn.snp.leading).offset(-16)
        }
        
        addFriendBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(56)
            $0.height.equalTo(40)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendProfileView.prepareForReuse()
        addFriendBtn.isSelected = false
    }
}

// MARK: - Configure

extension FriendAddTVC {
    func configureCell(_ friendInfo: FriendDefaultInfo) {
        friendProfileView.setProfile(friendInfo)
        addFriendBtn.isSelected = FriendStatusType.noFriend.isSelected ?? false
    }
}