//
//  CreateChallengeSuccuessVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/25.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class CreateChallengeSuccuessVC: CreateChallengeVC {
    
    // MARK: - UI components
    
    let successTitleLabel = PaddingLabel()
        .then {
            $0.text = "주간 챌린지가 \n만들어졌습니다!"
            $0.numberOfLines = 2
            $0.textAlignment = .center
//            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            $0.font = .title2
            $0.textColor = .gray900
            
            $0.backgroundColor = .clear
        }
    
    let successIconImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "checkCircle")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .main
        }
    
    let informationContainerView = UIView()
        .then {
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 16
        }
    
    let challengeTitleLabel = PaddingLabel()
        .then {
            $0.text = "가즈아!"
//            $0.textAlignment = .center
//            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            $0.font = .body1
            $0.textColor = .gray900
            
            $0.backgroundColor = .clear
        }
    let challengeDateLabel = PaddingLabel()
        .then {
            $0.text = "8월 22일 - 8월 29일"
//            $0.textAlignment = .center
//            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            $0.font = .body4
            $0.textColor = .gray600
            
            $0.backgroundColor = .clear
        }
    let userProfileStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .fill
        }
    let separateView = UIView()
        .then {
            $0.backgroundColor = .gray300
        }
    let explainLabel = PaddingLabel()
        .then {
            $0.text = "챌린지 시작일까지 수락한 친구들과 함께\n 챌린지가 진행됩니다."
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.font = .caption1
            $0.textColor = .gray600
        }
    
    // MARK: - Variables and Properties
    
    var createWeekChallengeVC: CreateWeekChallengeVC?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        _ = navigationBar
            .then {
                $0.naviType = .present
                $0.configureNaviBar(targetVC: self, title: "주간 챌린지 만들기")
                $0.configureBackBtn(targetVC: self)
            }
        
        _ = confirmButton
            .then {
                $0.setTitle("확인", for: .normal)
                $0.isEnabled = true
                
                $0.isSelected = true
            }
        
        for userProfile in 1...3 {
            let containerView = UIView()
            let profileImage = UIImageView()
                .then {
                    $0.image = UIImage(named: "defaultThumbnail")
                    $0.layer.cornerRadius = 28
                    $0.layer.masksToBounds = true
                }
            let nicknameLabel = PaddingLabel()
                .then {
                    $0.text = "아무개 \(userProfile)"
                    $0.font = .caption1
                    $0.textColor = .gray900
                }
            
            containerView.addSubviews([profileImage, nicknameLabel])
            profileImage.snp.makeConstraints {
                $0.width.height.equalTo(profileImage.layer.cornerRadius * 2)
                
                $0.top.left.right.equalTo(containerView)
            }
            nicknameLabel.snp.makeConstraints {
                $0.centerX.equalTo(profileImage)
                
                $0.top.equalTo(profileImage.snp.bottom).offset(8)
                $0.bottom.equalTo(containerView.snp.bottom)
            }
            
            userProfileStackView.addArrangedSubview(containerView)
            
        }
    }
    
    override func layoutView() {
        super.layoutView()
        
        view.addSubviews([successTitleLabel, successIconImageView, informationContainerView])
        informationContainerView.addSubviews([challengeTitleLabel, challengeDateLabel, userProfileStackView, separateView, explainLabel])
        
        
        successTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.lessThanOrEqualTo(navigationBar.snp.bottom).offset(60)
        }
        successIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(102)
            
            $0.centerX.equalTo(successTitleLabel)
            $0.top.equalTo(successTitleLabel.snp.bottom).offset(36)
        }
        
        informationContainerView.snp.makeConstraints {
            $0.width.equalTo(343)
//            $0.height.equalTo(275)
            
            $0.centerX.equalTo(successIconImageView)
            $0.top.equalTo(successIconImageView.snp.bottom).offset(36)
//            $0.bottom.equalTo(confirmButton.snp.top).offset(57)
        }
        challengeTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(informationContainerView)
            $0.top.equalTo(informationContainerView.snp.top).offset(28)
        }
        challengeDateLabel.snp.makeConstraints {
            $0.centerX.equalTo(challengeTitleLabel)
            $0.top.equalTo(challengeTitleLabel.snp.bottom).offset(8)
        }
        userProfileStackView.snp.makeConstraints {
//            $0.height.equalTo(75)
            
            $0.centerX.equalTo(challengeDateLabel)
            $0.top.equalTo(challengeDateLabel.snp.bottom).offset(16)
//            $0.horizontalEdges.equalTo(informationContainerView).inset(55.5)
        }
        separateView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.centerX.equalTo(userProfileStackView)
            $0.top.equalTo(userProfileStackView.snp.bottom).offset(32)
            $0.horizontalEdges.equalTo(informationContainerView).inset(16)
        }
        explainLabel.snp.makeConstraints {
            $0.centerX.equalTo(separateView)
            $0.top.equalTo(separateView.snp.bottom).offset(20)
            $0.bottom.equalTo(informationContainerView.snp.bottom).inset(28)
        }
    }
    
    override func didTapConfirmButton() {
        dismiss(animated: true, completion: { [self] in
            createWeekChallengeVC?.navigationController?.popToRootViewController(animated: true)
        })
        
    }
    
}
