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

class AddKakaoFriendTVC: BaseTableViewCell {
    private let friendProfileView = FriendCellProfileView()
    
    private let addFriendBtn = UIButton()
        .then {
            $0.layer.cornerRadius = 8
            $0.setBackgroundColor(.main, for: .normal)
            $0.setBackgroundColor(.gray100, for: .selected)
            $0.tintColor = $0.isSelected ? .gray500 : .white
        }
    
    private let bag = DisposeBag()
    
    override func configureView() {
        super.configureView()
        
        selectionStyle = .none
        contentView.addSubviews([friendProfileView,
                                 addFriendBtn])
        
        bindBtn()
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

extension AddKakaoFriendTVC {
    private func setButtonImage(_ isNEMODU: Bool) {
        if isNEMODU {
            addFriendBtn.setImage(UIImage(named: "addFriend")?.withRenderingMode(.alwaysTemplate), for: .normal)
            addFriendBtn.setImage(UIImage(named: "addedFriend")?.withRenderingMode(.alwaysTemplate), for: .selected)
        } else {
            addFriendBtn.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysTemplate), for: .normal)
            addFriendBtn.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysTemplate), for: .selected)
        }
    }
    
    func configureCell(_ friendInfo: KakaoFriendInfo) {
        friendProfileView.setKakaoProfile(friendInfo)
        setButtonImage(friendInfo.isSigned)
    }
}

// MARK: - Input

extension AddKakaoFriendTVC {
    func bindBtn() {
        addFriendBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.addFriendBtn.isSelected.toggle()
                self.addFriendBtn.tintColor = self.addFriendBtn.isSelected ? .gray500 : .white
            })
            .disposed(by: bag)
    }
}
