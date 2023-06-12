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
    
    private let baseContainerView = UIView()
    private let contentStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .center
        }
    
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
            $0.text = "----"
            $0.textColor = .gray900
            $0.font = .body1
            $0.textAlignment = .center
            $0.setLineBreakMode()
            
            $0.backgroundColor = .clear
        }
    private let challengeDateLabel = PaddingLabel()
        .then {
            $0.text = "-월 --일 - -월 --일"
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
        
        let startDate: Date? = String(creatChallengeResponseModel.started.split(separator: "T")[0]).toDate(.hyphen)
        let endDate: Date? = String(creatChallengeResponseModel.ended.split(separator: "T")[0]).toDate(.hyphen)
        if let startDate, let endDate {
            challengeDateLabel.text = "\(startDate.month.showTwoDigitNumber)월 \(startDate.day.showTwoDigitNumber)일 - \(endDate.month.showTwoDigitNumber)월 \(endDate.day.showTwoDigitNumber)일"
        }
        
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
                    $0.kf.setImage(with: joinUserInfo.picturePathURL, placeholder: UIImage.defaultThumbnail)
                    $0.layer.cornerRadius = 28
                    $0.layer.masksToBounds = true
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
        view.addSubviews([baseContainerView])
        baseContainerView.addSubviews([contentStackView])
        [successTitleLabel, successIconImageView, informationContainerView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        informationContainerView.addSubviews([challengeTitleLabel, challengeDateLabel, userProfileStackView, separateView, explainLabel])
        
        baseContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view)
            $0.bottom.equalTo(confirmButton.snp.top)
        }
        contentStackView.snp.makeConstraints {
            $0.centerY.horizontalEdges.equalTo(baseContainerView)
        }
        
        successIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(102)
        }
        
        informationContainerView.snp.makeConstraints {
            $0.width.equalTo(343)
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
