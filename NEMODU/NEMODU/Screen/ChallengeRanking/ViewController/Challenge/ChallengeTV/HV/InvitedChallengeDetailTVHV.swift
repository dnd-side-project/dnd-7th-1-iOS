//
//  InvitedChallengeDetailTVHV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/31.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class InvitedChallengeDetailTVHV : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    private let challengeTypeLabel = UILabel()
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
    private let weekChallengeTypeLabel = UILabel()
        .then {
            $0.text = "-----"
            $0.font = .body4
            $0.textColor = .gray600
        }
    
    private let challengeNameImage = UIImageView()
        .then {
            $0.image = UIImage(named: "badge_flag")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = ChallengeColorType(rawValue: "Pink")?.primaryColor
        }
    private let challengeNameLabel = UILabel()
        .then {
            $0.text = "-----"
            $0.font = .title3SB
            $0.textColor = .gray900
        }
    private let currentStateLabel = UILabel()
        .then {
            $0.text = "---- -월 -주차 (--.--~--.--)"
            $0.font = .body4
            $0.textColor = .gray600
        }
    
    private let guideLabelContainerView = UIView()
    private let guideLabel = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.textAlignment = .center
            
            let attributedText = NSMutableAttributedString(string: "친구들의 수락을 기다리고 있어요!\n", attributes: [NSAttributedString.Key.font: UIFont.body4,
                                                                                          NSAttributedString.Key.foregroundColor: UIColor.gray900])
            attributedText.append(NSAttributedString(string: "시작일이 되면 수락한 친구들과 챌린지가 시작됩니다.", attributes: [NSAttributedString.Key.font: UIFont.caption1,
                                                                                                          NSAttributedString.Key.foregroundColor: UIColor.gray500]))
            $0.attributedText = attributedText
        }
    
    private let acceptButton = UIButton()
        .then {
            $0.titleLabel?.font = .body2
            $0.setTitle("수락", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundColor(.main, for: .normal)
            $0.layer.cornerRadius = 8
        }
    private let rejectButton = UIButton()
        .then {
            $0.titleLabel?.font = .body2
            $0.setTitle("거절", for: .normal)
            $0.setTitleColor(.gray700, for: .normal)
            $0.setBackgroundColor(.gray100, for: .normal)
            $0.layer.cornerRadius = 8
        }
    
    private let borderLineView = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    private let invitedFriendsListTitleView = UIView()
    private let invitedFriendsListTitleLabel = UILabel()
        .then {
            $0.font = .body2
            let attributedText = NSMutableAttributedString(string: "함께할 친구 ", attributes: [NSAttributedString.Key.font: UIFont.body2,
                                                                                          NSAttributedString.Key.foregroundColor: UIColor.gray900])
            attributedText.append(NSAttributedString(string: "( - / - )", attributes: [NSAttributedString.Key.font: UIFont.body2,
                                                                                                          NSAttributedString.Key.foregroundColor: UIColor.gray600]))
            $0.attributedText = attributedText
        }
    
    // MARK: - Variables and Properties
    
    private let viewModel = InvitedChallengeDetailVM()
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureHV()
        configureLayoutView()
        bindButton()
        responseAcceptRejectChallenge()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func hideButtons() {
        rejectButton.snp.updateConstraints {
            $0.height.equalTo(0)
            $0.top.equalTo(guideLabelContainerView.snp.bottom).offset(0)
        }
    }
    
}

// MARK: - Configure

extension InvitedChallengeDetailTVHV {
    
    private func configureHV() {
        contentView.backgroundColor = .white
    }
    
}

// MARK: - Layout

extension InvitedChallengeDetailTVHV {
    
    private func configureLayoutView() {
        contentView.addSubviews([challengeTypeLabel, weekChallengeTypeLabel,
                                 challengeNameImage, challengeNameLabel,
                                 currentStateLabel,
                                 guideLabelContainerView,
                                 acceptButton, rejectButton,
                                 borderLineView,
                                 invitedFriendsListTitleView])
        guideLabelContainerView.addSubviews([guideLabel])
        invitedFriendsListTitleView.addSubviews([invitedFriendsListTitleLabel])
        
        
        challengeTypeLabel.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(challengeTypeLabel.layer.cornerRadius * 2)
            
            $0.top.left.equalTo(contentView).offset(16)
        }
        weekChallengeTypeLabel.snp.makeConstraints {
            $0.centerY.equalTo(challengeTypeLabel)
            
            $0.left.equalTo(challengeTypeLabel.snp.right).offset(8)
        }
        
        challengeNameImage.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(challengeNameImage.snp.width)
            
            $0.top.equalTo(challengeTypeLabel.snp.bottom).offset(20)
            $0.left.equalTo(challengeTypeLabel.snp.left)
        }
        challengeNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(challengeNameImage)
            
            $0.left.equalTo(challengeNameImage.snp.right).offset(8)
            $0.right.equalTo(contentView.snp.right).inset(16)
        }
        currentStateLabel.snp.makeConstraints {
            $0.top.equalTo(challengeNameImage.snp.bottom).offset(12)
            $0.left.equalTo(challengeNameImage.snp.left)
            $0.right.equalTo(challengeNameLabel.snp.right)
        }
        
        guideLabelContainerView.snp.makeConstraints {
            $0.height.equalTo(58)
            
            $0.top.equalTo(currentStateLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(contentView)
        }
        guideLabel.snp.makeConstraints {
            $0.center.equalTo(guideLabelContainerView)
        }
        
        rejectButton.snp.makeConstraints {
            $0.width.equalTo(167.5)
            $0.height.equalTo(42)
            
            $0.top.equalTo(guideLabelContainerView.snp.bottom).offset(12)
            $0.left.equalTo(currentStateLabel.snp.left)
        }
        acceptButton.snp.makeConstraints {
            $0.width.height.equalTo(rejectButton)
            $0.centerY.equalTo(rejectButton)
            
            $0.right.equalTo(currentStateLabel.snp.right)
        }
        
        borderLineView.snp.makeConstraints {
            $0.height.equalTo(8)

            $0.top.equalTo(rejectButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(contentView)
        }
        
        invitedFriendsListTitleView.snp.makeConstraints {
            $0.height.equalTo(56)

            $0.top.equalTo(borderLineView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(contentView)
        }
        invitedFriendsListTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(invitedFriendsListTitleView)
            
            $0.left.equalTo(rejectButton.snp.left)
        }
    }
    
}


// MARK: - Input

extension InvitedChallengeDetailTVHV {
    
    private func bindButton() {
        acceptButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                // TODO: - 서버연결
//                guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
//                self.viewModel.requestAcceptChallenge(with: <#T##AcceptRejectChallengeRequestModel#>)
            })
            .disposed(by: bag)
        
        rejectButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                // TODO: - 서버연결
//                guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
//                self.viewModel.requestAcceptChallenge(with: <#T##AcceptRejectChallengeRequestModel#>)
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension InvitedChallengeDetailTVHV {
    private func responseAcceptRejectChallenge() {
        
        viewModel.output.isAcceptChallengeSuccess
            .subscribe(onNext: {_ in
                
                // TODO: - 서버연결 후 작업
            })
            .disposed(by: bag)

        viewModel.output.isRejectChallengeSuccess
            .subscribe(onNext: {_ in
                
                // TODO: - 서버연결 후 작업
            })
            .disposed(by: bag)
        
    }
}
