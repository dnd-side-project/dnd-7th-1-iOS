//
//  InvitedChallengeTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class InvitedChallengeTVC : BaseTableViewCell {
    
    // MARK: - UI components
    
    private let contentsView = UIView()
        .then {
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
    
    private let timeStatusLabel = UILabel()
        .then {
            $0.text = "주간"
            $0.font = .caption1
            $0.textColor = .main
            $0.backgroundColor = .clear
            $0.textAlignment = .center
            
            $0.layer.cornerRadius = 11
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.main.cgColor
        }
    
    private let challengeNameLabel = UILabel()
        .then {
            $0.text = "챌린지 이름"
            $0.font = .body3
            $0.textColor = .gray900
        }
    private let timeAgoLabel = UILabel()
        .then {
            $0.text = "- 분 전"
            $0.font = .caption1
            $0.textColor = .gray500
        }
    private let notYetCheckDetailCircleView = UIView()
        .then {
            $0.backgroundColor = .red100
            $0.layer.cornerRadius = 3
            $0.layer.masksToBounds = true
        }
    
    private let userProfileImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
    private let userNicknameLabel = UILabel()
        .then {
            $0.text = "친구 닉네임"
            $0.font = .body4
            $0.textColor = .gray900
        }
    private let invitedMessage = UILabel()
        .then {
            $0.text = "초대 메세지: -"
            $0.font = .caption1
            $0.textColor = .gray500
        }
    lazy var seeDetailButton = UIButton()
        .then {
            $0.setTitle("상세보기", for: .normal)
            $0.titleLabel?.font = .caption1
            $0.setTitleColor(.gray700, for: .normal)
            $0.backgroundColor = .gray200
            
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        }
        
    // MARK: - Variables and Properties
    
    var challengeVC: ChallengeVC?
    var uuid: String?
    
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
        bindButton()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Function
    
}

// MARK: - Configure

extension InvitedChallengeTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
    func configureInvitedChallengeTVC(invitedChallengeListElement: InvitedChallengeListElement) {
        uuid = invitedChallengeListElement.uuid
        
        challengeNameLabel.text = invitedChallengeListElement.name
        timeAgoLabel.text = "\(invitedChallengeListElement.created.relativeDateTime(.withBlank))"
        userProfileImageView.kf.setImage(with: invitedChallengeListElement.picturePathURL, placeholder: UIImage.defaultThumbnail)
    
        userNicknameLabel.text = invitedChallengeListElement.inviterNickname
        invitedMessage.text = "초대 메세지: \(invitedChallengeListElement.message)"
    }
    
}

// MARK: - Layout

extension InvitedChallengeTVC {
    
    private func configureLayout() {
        contentView.addSubview(contentsView)
        contentsView.addSubviews([timeStatusLabel, challengeNameLabel, timeAgoLabel, notYetCheckDetailCircleView])
        contentsView.addSubviews([userProfileImageView, userNicknameLabel, invitedMessage, seeDetailButton])
        
        
        contentsView.snp.makeConstraints {
            let paddingTB = 12
            
            $0.top.equalTo(contentView.snp.top).offset(paddingTB)
            $0.horizontalEdges.equalTo(contentView).inset(16)
            $0.bottom.equalTo(contentView.snp.bottom).inset(paddingTB / 2)
        }
        
        timeStatusLabel.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(timeStatusLabel.layer.cornerRadius * 2)
            
            $0.top.equalTo(contentsView.snp.top).offset(16)
            $0.left.equalTo(contentsView.snp.left).offset(12)
        }
        challengeNameLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            
            $0.centerY.equalTo(timeStatusLabel)
            $0.left.equalTo(timeStatusLabel.snp.right).offset(8)
            $0.right.equalTo(timeAgoLabel.snp.left).inset(-8)
        }
        timeAgoLabel.snp.makeConstraints {
            $0.height.equalTo(13)

            $0.centerY.equalTo(timeStatusLabel)
            $0.right.equalTo(notYetCheckDetailCircleView.snp.left).inset(-4)
        }
        notYetCheckDetailCircleView.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.width.equalTo(notYetCheckDetailCircleView.snp.height)
            
            $0.top.equalTo(contentsView.snp.top).offset(20.5)
            $0.right.equalTo(contentsView.snp.right).inset(12)
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.height.equalTo(userProfileImageView.layer.cornerRadius * 2)
            $0.width.equalTo(userProfileImageView.snp.height)
            
            $0.top.equalTo(timeStatusLabel.snp.bottom).offset(4)
            $0.left.equalTo(timeStatusLabel.snp.left)
        }
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.top).offset(3)
            $0.left.equalTo(userProfileImageView.snp.right).offset(8)
            $0.right.equalTo(seeDetailButton.snp.left).inset(-8)
        }
        invitedMessage.snp.makeConstraints {
            $0.top.equalTo(userNicknameLabel.snp.bottom).offset(4)
            $0.left.equalTo(userNicknameLabel.snp.left)
            $0.right.equalTo(seeDetailButton.snp.left).inset(-8)
        }
        seeDetailButton.snp.makeConstraints {
            $0.width.equalTo(66)
            $0.height.equalTo(seeDetailButton.layer.cornerRadius * 2)
            
            $0.centerY.equalTo(userProfileImageView)
            $0.right.equalTo(notYetCheckDetailCircleView.snp.right)
        }
    }
    
}

// MARK: - Bind

extension InvitedChallengeTVC {
    
    private func bindButton() {
        seeDetailButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let invitedChallengeDetailVC = InvitedChallengeDetailVC()
                invitedChallengeDetailVC.uuid = self.uuid ?? ""
                invitedChallengeDetailVC.getInvitedChallengeDetailInfo()
                
                invitedChallengeDetailVC.hidesBottomBarWhenPushed = true
                self.challengeVC?.navigationController?.pushViewController(invitedChallengeDetailVC, animated: true)
            })
            .disposed(by: bag)
    }
    
}
