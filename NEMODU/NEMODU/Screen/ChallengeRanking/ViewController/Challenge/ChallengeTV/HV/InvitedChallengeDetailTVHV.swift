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

class InvitedChallengeDetailTVHV : ChallengeDetailTVHV {
    
    // MARK: - UI components
    
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
        }
    
    // MARK: - Variables and Properties
    
    var invitedChallengeDetailVC: InvitedChallengeDetailVC?
    
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureInvitedFriendsListTitleLabel(friendsCnt: 0)
        
        bindButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func configureInvitedChallengeDetailTVHV(invitedChallengeDetailInfo: InvitedChallengeDetailResponseModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateType.withTime.dateFormatter
        guard let startDate: Date = dateFormatter.date(from: invitedChallengeDetailInfo.started) else { return }
        guard let endDate: Date = dateFormatter.date(from: invitedChallengeDetailInfo.ended) else { return }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let weekOfMonth = calendar.component(.weekOfMonth, from: invitedChallengeDetailInfo.started.toDate(.hyphen))
        
        weekChallengeTypeLabel.text = ChallengeType(rawValue: invitedChallengeDetailInfo.type)?.title
        challengeNameImage.tintColor = ChallengeColorType(rawValue: invitedChallengeDetailInfo.color)?.primaryColor
        challengeNameLabel.text = invitedChallengeDetailInfo.name
        currentStateLabel.text = "\(startDate.year) \(startDate.month.showTwoDigitNumber)월 \(weekOfMonth)주차 (\(startDate.month.showTwoDigitNumber).\(startDate.day.showTwoDigitNumber)~\(endDate.month.showTwoDigitNumber).\(endDate.day.showTwoDigitNumber))"
        configureInvitedFriendsListTitleLabel(friendsCnt: invitedChallengeDetailInfo.infos.count)
        
        updateInviteChallengeByMyUserStatus(infos: invitedChallengeDetailInfo.infos)
    }
    
    private func updateInviteChallengeByMyUserStatus(infos: [InvitedChallengeDetailInfo]) {
        let myUserNickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)
        
        for info in infos {
            if info.nickname == myUserNickname {
                switch info.status {
                case InvitedChallengeAcceptType.progress.description:
                    rejectButton.isHidden = true
                    acceptButton.isHidden = true
                    
                    let acceptedLabel = UILabel()
                        .then {
                            $0.font = .body2
                            $0.textColor = .gray400
                            $0.backgroundColor = .gray100
                            
                            $0.text = "수락 완료!"
                            $0.textAlignment = .center
                            
                            $0.clipsToBounds = true
                            $0.layer.cornerRadius = 8
                        }
                    
                    contentView.addSubview(acceptedLabel)
                    acceptedLabel.snp.makeConstraints {
                        $0.height.equalTo(rejectButton.snp.height)
                        $0.top.equalTo(rejectButton.snp.top)
                        $0.left.right.equalTo(currentStateLabel)
                    }
                case InvitedChallengeAcceptType.master.description,
                    InvitedChallengeAcceptType.reject.description:
                    rejectButton.snp.updateConstraints {
                        $0.height.equalTo(0)
                        $0.top.equalTo(guideLabelContainerView.snp.bottom).offset(0).priority(.high)
                    }
                default:
                    break
                }
            }
        }
    }
    
    override func configureLayoutView() {
        super.configureLayoutView()
        
        contentView.addSubviews([guideLabelContainerView,
                                 acceptButton, rejectButton,
                                 borderLineView,
                                 invitedFriendsListTitleView])
        guideLabelContainerView.addSubviews([guideLabel])
        invitedFriendsListTitleView.addSubviews([invitedFriendsListTitleLabel])
        
        
        guideLabelContainerView.snp.makeConstraints {
            $0.height.equalTo(58).priority(.high)
            
            $0.top.equalTo(currentStateLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(contentView)
        }
        guideLabel.snp.makeConstraints {
            $0.center.equalTo(guideLabelContainerView)
        }
        
        rejectButton.snp.makeConstraints {
            $0.width.equalTo(167.5)
            $0.height.equalTo(42)
            
            $0.top.equalTo(guideLabelContainerView.snp.bottom).offset(12).priority(.high)
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

// MARK: - Configure

extension InvitedChallengeDetailTVHV {
    
    private func configureInvitedFriendsListTitleLabel(friendsCnt: Int) {
        let titleString = friendsCnt == 0 ? "( - / - )" : "( \(friendsCnt) / 4 )"
        let attributedText = NSMutableAttributedString(string: "함께할 친구 ", attributes: [NSAttributedString.Key.font: UIFont.body2,
                                                                                      NSAttributedString.Key.foregroundColor: UIColor.gray900])
        attributedText.append(NSAttributedString(string: titleString, attributes: [NSAttributedString.Key.font: UIFont.body2,
                                                                                                      NSAttributedString.Key.foregroundColor: UIColor.gray600]))
        invitedFriendsListTitleLabel.attributedText = attributedText
    }
    
}

// MARK: - Input

extension InvitedChallengeDetailTVHV {
    
    private func bindButton() {
        acceptButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.invitedChallengeDetailVC?.didTapAcceptButton()
            })
            .disposed(by: bag)
        
        rejectButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.invitedChallengeDetailVC?.didTapRejectButton()
            })
            .disposed(by: bag)
    }
    
}
