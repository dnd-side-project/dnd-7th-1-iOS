//
//  RankingUserTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/20.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class RankingUserTVC : BaseTableViewCell {
    
    // MARK: - UI components
    
    private let contentsView = UIView()
        .then {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.clear.cgColor
        }
    
    private let rankNumberLabel = UILabel()
        .then {
            $0.text = "-"
            $0.font = .headline1
            $0.textColor = .gray700
            $0.backgroundColor = .clear
            $0.textAlignment = .center
        }
    private let userProfileImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
    private let showMeLabel = UILabel()
        .then {
            $0.text = "나"
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = .PretendardRegular(size: 10)
            
            $0.backgroundColor = .secondary
            
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            $0.isHidden = true
        }
    private let userNicknameLabel = UILabel()
        .then {
            $0.text = "-"
            $0.font = .body1
            $0.textColor = .gray900
        }
    private let blocksNumberLabel = UILabel()
        .then {
            $0.text = "-"
            $0.insertComma()
            $0.font = .title2
            $0.textColor = .gray900
        }
    private let blockLabel = UILabel()
        .then {
            $0.text = "칸"
            $0.font = .body1
            $0.textColor = .gray700
        }
        
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configreLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userNicknameLabel.text = ""
        
        blocksNumberLabel.text = "-"
        blockLabel.text = "칸"
        
        markTop123(isOn: false)
        markRankLabelGreen(isOn: false)
        markRankLayerGreen(isOn: false)
    }
    
    // MARK: - Functions
    
    /// 해당 파라미터의 닉네임이 현재 로그인한 사용자인지 확인해주는 함수
    private func isMyNickname(nickname: String) -> Bool {
        return nickname == UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ? true : false
    }
    
    /// 랭킹목록 1,2,3등 표시 설정 함수
    private func markTop123(isOn: Bool) {
        rankNumberLabel.textColor = isOn ? .main : .gray700
        contentsView.layer.backgroundColor = isOn ? UIColor.gray50.cgColor : UIColor.clear.cgColor
    }
    
    /// 랭킹 항목 중 닉네임에 초록색을 설정하는 함수
    private func markRankLabelGreen(isOn: Bool) {
        rankNumberLabel.textColor = isOn ? .main : .gray700
        userNicknameLabel.textColor = isOn ? .main : .gray900
        
        blocksNumberLabel.textColor = isOn ? .main : .gray900
        blockLabel.textColor = isOn ? .main : .gray700
    }
    
    /// 랭킹 항목 중 셀 배경과 테두리에 초록색을 설정하는 함수
    private func markRankLayerGreen(isOn: Bool) {
        contentsView.layer.borderColor = isOn ? UIColor.main.cgColor : UIColor.clear.cgColor
        contentsView.layer.backgroundColor = isOn ? UIColor.main.withAlphaComponent(0.1).cgColor : UIColor.clear.withAlphaComponent(0.1).cgColor
    }
    
}

// MARK: - Configure

extension RankingUserTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
    /// 기본적인 랭킹 목록 정보를 입력하는 함수
    func configureRankingCell(rankNumber: Int, profileImageURL: URL?, nickname: String, blocksNumber: Int) {
        rankNumberLabel.text = "\(rankNumber)"
        userProfileImageView.kf.setImage(with: profileImageURL, placeholder: UIImage.defaultThumbnail)
        showMeLabel.isHidden = !isMyNickname(nickname: nickname)
        
        userNicknameLabel.text = nickname
        blocksNumberLabel.text = "\(blocksNumber.insertComma)"
    }
    
    /// 영역(Area), 걸음수(Step), 역대 누적(Accumulate) 랭킹 목록의 특정상황(1,2,3위 / 자신랭킹) 표시 함수
    func configureRankingListCell(rankNumber: Int, nickname: String) {
        markTop123(isOn: 1 <= rankNumber && rankNumber <= 3 ? true : false)
        
        if isMyNickname(nickname: nickname) {
            markRankLabelGreen(isOn: true)
        }
    }
    
    /// 걸음수(Step) 랭킹에 표시되는 기본 단위 설정
    func configureStepRankingCell() {
        blockLabel.text = "걸음"
    }
    
    /// 랭킹 목록 최상단에 고정된 자신의 랭킹 항목을 설정하는 함수
    func configureRankingTopCell() {
        markRankLayerGreen(isOn: true)
        markRankLabelGreen(isOn: false)
    }
    
    /// 진행중, 진행완료 챌린지에 표시되는 사용자 랭킹 목록을 설정하는 함수
    func configureChallengeDetailRankingCell(nickname: String) {
        rankNumberLabel.textColor = .gray700
        contentsView.layer.backgroundColor = UIColor.gray50.cgColor
        
        if isMyNickname(nickname: nickname) {
            markRankLayerGreen(isOn: true)
            markRankLabelGreen(isOn: false)
        }
    }
    
}

// MARK: - Layout

extension RankingUserTVC {
    
    private func configreLayout() {
        contentView.addSubview(contentsView)
        contentsView.addSubviews([rankNumberLabel, userProfileImageView, showMeLabel, userNicknameLabel, blocksNumberLabel, blockLabel])
        
        contentsView.snp.makeConstraints {
            let paddingTB = 12
            
            $0.top.equalTo(contentView.snp.top)
            $0.horizontalEdges.equalTo(contentView).inset(16)
            $0.bottom.equalTo(contentView.snp.bottom).inset(paddingTB)
        }
        
        rankNumberLabel.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(20)
            
            $0.centerY.equalTo(contentsView)
            $0.left.equalTo(contentsView.snp.left).offset(16)
        }
        userProfileImageView.snp.makeConstraints {
            $0.width.equalTo(userProfileImageView.layer.cornerRadius * 2)
            $0.height.equalTo(userProfileImageView.snp.width)

            $0.centerY.equalTo(rankNumberLabel)
            $0.left.equalTo(rankNumberLabel.snp.right).offset(4)
        }
        showMeLabel.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(showMeLabel.snp.width)
            
            $0.right.equalTo(userProfileImageView.snp.right)
            $0.bottom.equalTo(userProfileImageView.snp.bottom)
        }
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageView)
            $0.left.equalTo(userProfileImageView.snp.right).offset(16)
        }
        blocksNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(userNicknameLabel)
            $0.left.lessThanOrEqualTo(userNicknameLabel.snp.right)
        }
        blockLabel.snp.makeConstraints {
            $0.centerY.equalTo(blocksNumberLabel)
            $0.left.equalTo(blocksNumberLabel.snp.right).offset(4)
            $0.right.equalTo(contentsView.snp.right).inset(24)
        }
    }
    
}
