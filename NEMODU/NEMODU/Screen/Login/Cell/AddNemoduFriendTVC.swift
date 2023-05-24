//
//  AddNemoduFriendTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AddNemoduFriendTVC: BaseTableViewCell {
    private let friendProfileView = FriendCellProfileView()
    
    private let addFriendBtn = UIButton()
        .then {
            $0.layer.cornerRadius = 8
            $0.setBackgroundColor(.main, for: .normal)
            $0.setBackgroundColor(.gray100, for: .selected)
            $0.setImage(UIImage(named: "addFriend"), for: .normal)
            $0.setImage(UIImage(named: "addedFriend"), for: .selected)
        }
    
    private var viewModel = RecommendListVM()
    private let bag = DisposeBag()
    weak var popupToastViewDelegate: PopupToastViewDelegate?
    weak var editFriendListDelegate: EditFriendListDelegate?
    
    override func configureView() {
        super.configureView()
        
        selectionStyle = .none
        contentView.addSubviews([friendProfileView,
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

extension AddNemoduFriendTVC {
    func configureCell(_ friendInfo: FriendDefaultInfo) {
        friendProfileView.setProfile(friendInfo)
        
        bindBtn()
        bindAPIResult()
    }
    
    func configureSignupCell(_ friendInfo: FriendDefaultInfo, delegate: EditFriendListDelegate) {
        friendProfileView.setProfile(friendInfo)
        editFriendListDelegate = delegate
        
        bindSignupFriendList()
    }
}

// MARK: - Input

extension AddNemoduFriendTVC {
    private func bindBtn() {
        addFriendBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let friend = self.friendProfileView.getNickname()
                else { return }
                !self.addFriendBtn.isSelected
                ? self.viewModel.requestFriend(to: FriendRequestModel(friendNickname: friend))
                : self.viewModel.deleteFriend(to: FriendRequestModel(friendNickname: friend))
            })
            .disposed(by: bag)
    }
    
    private func bindSignupFriendList() {
        addFriendBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let friend = self.friendProfileView.getNickname()
                else { return }
                !self.addFriendBtn.isSelected
                ? self.editFriendListDelegate?.addFriend(friend)
                : self.editFriendListDelegate?.removeFriend(friend)
                self.addFriendBtn.isSelected.toggle()
            })
            .disposed(by: bag)
    }
    
    private func bindAPIResult() {
        viewModel.requestStatus
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] status in
                guard let self = self else { return }
                if status {
                    self.addFriendBtn.isSelected.toggle()
                    self.addFriendBtn.tintColor = self.addFriendBtn.isSelected ? .gray500 : .white
                    self.popupToastViewDelegate?.popupToastView(.postFriendRequest)
                }
            })
            .disposed(by: bag)
        
        viewModel.deleteStatus
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] status in
                guard let self = self else { return }
                if status {
                    self.addFriendBtn.isSelected.toggle()
                    self.addFriendBtn.tintColor = self.addFriendBtn.isSelected ? .gray500 : .white
                    self.popupToastViewDelegate?.popupToastView(.cancelFriendRequest)
                }
            })
            .disposed(by: bag)
    }
}
