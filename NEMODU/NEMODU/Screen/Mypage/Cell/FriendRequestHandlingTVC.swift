//
//  FriendRequestTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

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
    
    weak var delegate: FriendRequestHandlingDelegate?
    private var indexPath: IndexPath?
    private let bag = DisposeBag()
    
    override func configureView() {
        super.configureView()
        
        selectionStyle = .none
        contentView.addSubviews([friendProfileView,
                                 acceptFriendBtn,
                                 refuseFriendBtn])
        
        bindRequestHandlingBtn()
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
    func configureCell(_ friendInfo: FriendDefaultInfo,
                       indexPath: IndexPath,
                       delegate: FriendRequestHandlingDelegate) {
        friendProfileView.setProfile(friendInfo)
        self.indexPath = indexPath
        self.delegate = delegate
    }
}

// MARK: - Input

extension FriendRequestHandlingTVC {
    func bindRequestHandlingBtn() {
        acceptFriendBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let nickname = self.friendProfileView.getNickname(),
                      let indexPath = self.indexPath
                else { return }
                self.delegate?.acceptFriendRequest(nickname: nickname,
                                                   indexPath: indexPath)
            })
            .disposed(by: bag)
        
        refuseFriendBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let nickname = self.friendProfileView.getNickname(),
                      let indexPath = self.indexPath
                else { return }
                self.delegate?.refuseFriendRequest(nickname: nickname,
                                                   indexPath: indexPath)
            })
            .disposed(by: bag)
    }
}

protocol FriendRequestHandlingDelegate: AnyObject {
    func acceptFriendRequest(nickname: String,
                             indexPath: IndexPath)
    
    func refuseFriendRequest(nickname: String,
                             indexPath: IndexPath)
}
