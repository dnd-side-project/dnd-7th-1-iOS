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
    
    private let rankingUserView = RankingUserView()
    
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
        
        rankingUserView.userNicknameLabel.text = ""
        
        rankingUserView.blocksNumberLabel.text = "-"
        rankingUserView.blockLabel.text = "칸"
        
        rankingUserView.markTop123(isOn: false)
        rankingUserView.markRankLabelGreen(isOn: false)
        rankingUserView.markRankLayerGreen(isOn: false)
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension RankingUserTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
    /// 기본적인 랭킹 목록 정보를 입력하는 함수
    func configureRankingCell(rankNumber: Int, profileImageURL: URL?, nickname: String, blocksNumber: Int) {
        rankingUserView.configureRankingUserView(rankNumber: rankNumber, profileImageURL: profileImageURL, nickname: nickname, blocksNumber: blocksNumber)
    }
    
    /// 영역(Area), 걸음수(Step), 역대 누적(Accumulate) 랭킹 목록의 특정상황(1,2,3위 / 자신랭킹) 표시 함수
    func configureRankingListCell(rankNumber: Int, nickname: String) {
        rankingUserView.markTop123(isOn: 1 <= rankNumber && rankNumber <= 3 ? true : false)
        
        if rankingUserView.isMyNickname(nickname: nickname) {
            rankingUserView.markRankLabelGreen(isOn: true)
        }
    }
    
    /// 걸음수(Step) 랭킹 셀 일 때 호출
    func configureStepRankingCell() {
        rankingUserView.configureStepRanking()
    }
    
    /// 진행중, 진행완료 챌린지에 표시되는 사용자 랭킹 목록을 설정하는 함수
    func configureChallengeDetailRankingCell(nickname: String) {
        rankingUserView.rankNumberLabel.textColor = .gray700
        rankingUserView.contentsView.layer.backgroundColor = UIColor.gray50.cgColor
        
        if rankingUserView.isMyNickname(nickname: nickname) {
            rankingUserView.markRankLayerGreen(isOn: true)
            rankingUserView.markRankLabelGreen(isOn: false)
        }
    }
    
}

// MARK: - Layout

extension RankingUserTVC {
    
    private func configreLayout() {
        contentView.addSubview(rankingUserView)
        
        rankingUserView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
}
