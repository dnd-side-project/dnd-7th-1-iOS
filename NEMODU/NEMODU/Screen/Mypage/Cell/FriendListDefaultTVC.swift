//
//  FriendListTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class FriendListDefaultTVC: BaseTableViewCell {
    private let friendProfileView = FriendCellProfileView()
    
    private let deleteFriendBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "dismiss")?.withTintColor(.gray500),
                        for: .normal)
            $0.isHidden = true
        }
    
    weak var delegate: DeleteFriendDelegate?
    private var indexPath: IndexPath?
    private let bag = DisposeBag()
    
    override func configureView() {
        super.configureView()
        
        contentView.addSubviews([friendProfileView,
                                 deleteFriendBtn])
        
        bindDeleteFriendBtn()
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
    func configureCell(_ friendInfo: FriendDefaultInfo, isEditing: Bool, deleteDelegate: DeleteFriendDelegate, indexPath: IndexPath) {
        friendProfileView.setProfile(friendInfo)
        deleteFriendBtn.isHidden = !isEditing
        selectionStyle = isEditing ? .none : .default
        self.delegate = deleteDelegate
        self.indexPath = indexPath
    }
}

// MARK: - Input

extension FriendListDefaultTVC {
    /// 삭제 목록에 추가하고 tableView에서 cell을 지우는 삭제 확인 알람창을 띄우는 메서드
    private func bindDeleteFriendBtn() {
        deleteFriendBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let nickname = self.friendProfileView.getNickname(),
                      let indexPath = self.indexPath
                else { return }
                self.delegate?.popupDeleteAlert(nickname: nickname, indexPath: indexPath)
            })
            .disposed(by: bag)
    }
}

// MARK: - Delete Friend Delegate

protocol DeleteFriendDelegate: AnyObject {
    func popupDeleteAlert(nickname: String, indexPath: IndexPath)
}
