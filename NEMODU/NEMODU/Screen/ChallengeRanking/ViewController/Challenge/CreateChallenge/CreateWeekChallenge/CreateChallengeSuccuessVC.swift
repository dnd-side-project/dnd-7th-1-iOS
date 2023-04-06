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
    
    private let successTitleLabel = PaddingLabel()
        .then {
            $0.text = "주간 챌린지가 \n만들어졌습니다!"
            $0.numberOfLines = 2
            $0.textAlignment = .center
            
            $0.font = .title2
            $0.textColor = .gray900
            
            $0.backgroundColor = .clear
        }
    
    private let successIconImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "checkCircle")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .main
        }
    
    private let informationContainerView = UIView()
        .then {
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 16
        }
    
    private let challengeTitleLabel = PaddingLabel()
        .then {
            $0.text = "가즈아!"
            $0.font = .body1
            $0.textColor = .gray900
            
            $0.backgroundColor = .clear
        }
    private let challengeDateLabel = PaddingLabel()
        .then {
            $0.text = "8월 22일 - 8월 29일" // TODO: - 추후 기본 표시값 수정
            $0.font = .body4
            $0.textColor = .gray600
            
            $0.backgroundColor = .clear
        }
    private let userProfileStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .fill
        }
    private let separateView = UIView()
        .then {
            $0.backgroundColor = .gray300
        }
    private let explainLabel = PaddingLabel()
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
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
        configureConfirmButton()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
    override func didTapConfirmButton() {
        dismiss(animated: true, completion: { [self] in
            createWeekChallengeVC?.navigationController?.popToRootViewController(animated: true)
        })
    }
    
}

// MARK: - Configure

extension CreateChallengeSuccuessVC {
    
    func configureCreateChallengeResponse(creatChallengeResponseModel: CreatChallengeResponseModel) {
        challengeTitleLabel.text = creatChallengeResponseModel.message
        
        let startDates = creatChallengeResponseModel.started.parsingResponseValueTime()
        let endDates = creatChallengeResponseModel.ended.parsingResponseValueTime()
        challengeDateLabel.text = "\(startDates.month)월 \(startDates.day)일 - \(endDates.month)월 \(endDates.day)일"
        
        configureJoinUserInfo(joinUsersInfo: creatChallengeResponseModel.members)
    }
    
    private func configureNavigationBar() {
        _ = navigationBar
            .then {
                $0.naviType = .present
                $0.configureNaviBar(targetVC: self, title: "주간 챌린지 만들기")
                $0.configureBackBtn(targetVC: self)
            }
    }
    
    private func configureConfirmButton() {
        _ = confirmButton
            .then {
                $0.setTitle("확인", for: .normal)
                $0.isEnabled = true
                
                $0.isSelected = true
            }
    }
    
    private func configureJoinUserInfo(joinUsersInfo: [Member]) {
        for joinUserInfo in joinUsersInfo {
            let containerView = UIView()
            let profileImageView = UIImageView()
                .then {
                    $0.kf.setImage(with: URL(string: joinUserInfo.picturePath))
                    $0.layer.cornerRadius = 28
                    $0.layer.masksToBounds = true
                }
            if profileImageView.image == nil {
                profileImageView.image = .defaultThumbnail
            }
            
            let nicknameLabel = PaddingLabel()
                .then {
                    $0.text = joinUserInfo.nickname
                    $0.font = .caption1
                    $0.textColor = .gray900
                }
            
            containerView.addSubviews([profileImageView, nicknameLabel])
            profileImageView.snp.makeConstraints {
                $0.width.height.equalTo(profileImageView.layer.cornerRadius * 2)
                
                $0.top.left.right.equalTo(containerView)
            }
            nicknameLabel.snp.makeConstraints {
                $0.centerX.equalTo(profileImageView)
                
                $0.top.equalTo(profileImageView.snp.bottom).offset(8)
                $0.bottom.equalTo(containerView.snp.bottom)
            }
            
            userProfileStackView.addArrangedSubview(containerView)
        }
    }
    
}

// MARK: - Layout

extension CreateChallengeSuccuessVC {
    
    private func configureLayout() {
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
            
            $0.centerX.equalTo(successIconImageView)
            $0.top.equalTo(successIconImageView.snp.bottom).offset(36)
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
            $0.centerX.equalTo(challengeDateLabel)
            $0.top.equalTo(challengeDateLabel.snp.bottom).offset(16)
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
    
}
