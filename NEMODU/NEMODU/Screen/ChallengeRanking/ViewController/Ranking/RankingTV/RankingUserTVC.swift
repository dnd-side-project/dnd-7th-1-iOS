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
            $0.image = UIImage(named: "defaultThumbnail")
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
    let blockLabel = UILabel()
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
        markMyRanking(isOn: false)
    }
    
    // MARK: - Functions
    
    func markTop123(isOn: Bool) {
        switch isOn {
        case true:
            rankNumberLabel.textColor = .main
            contentsView.layer.backgroundColor = UIColor.gray50.cgColor
            showMeLabel.isHidden = true
        case false:
            rankNumberLabel.textColor = .main
            contentsView.layer.backgroundColor = UIColor.clear.cgColor
            showMeLabel.isHidden = false
        }
    }
    
    func markMyRanking(isOn: Bool) {
        switch isOn {
        case true:
            rankNumberLabel.textColor = .main
            showMeLabel.isHidden = false
            userNicknameLabel.textColor = .main
            
            blocksNumberLabel.textColor = .main
            blockLabel.textColor = .main
            
        case false:
            rankNumberLabel.textColor = .gray700
            showMeLabel.isHidden = true
            userNicknameLabel.textColor = .gray900
            
            blocksNumberLabel.textColor = .gray900
            blockLabel.textColor = .gray700
        }
    }
    
    func markMyRankingTVC(rankNumber: Int, myNickname: String, blocksNumber: Int) {
        rankNumberLabel.text = String(rankNumber)
        
        showMeLabel.isHidden = false
        
        userNicknameLabel.text = myNickname
        
        contentsView.layer.borderColor = UIColor.main.cgColor
        contentsView.layer.backgroundColor = UIColor.main.withAlphaComponent(0.1).cgColor
        
        blocksNumberLabel.text = String(blocksNumber)
    }
    
}

// MARK: - Configure

extension RankingUserTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
    // MARK: - configure TVC acording to Ranking Type
    
    func configureAreaRankingCell(with data: AreaRanking) {
        rankNumberLabel.text = "\(data.rank)"
//        userProfileImageView.image = // TODO: - 프로필 이미지 추가
        userNicknameLabel.text = data.nickname
        blocksNumberLabel.text = "\(data.score)"
        
        switch data.rank {
        case 1,2,3:
            markTop123(isOn: true)
        default:
            break
        }
        
        if(data.nickname == UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)) {
            markMyRanking(isOn: true)
        }
    }
    
    func configureStepRankingCell(with data: StepRanking) {
        rankNumberLabel.text = "\(data.rank)"
//        userProfileImageView.image = // TODO: - 프로필 이미지 추가
        userNicknameLabel.text = data.nickname
        blocksNumberLabel.text = "\(data.score)"
        
        switch data.rank {
        case 1,2,3:
            markTop123(isOn: true)
        default:
            break
        }
        
        if(data.nickname == UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)) {
            markMyRanking(isOn: true)
        }
    }
    
    func configureAccumulateRankingCell(with data: MatrixRanking) {
        rankNumberLabel.text = "\(data.rank)"
//        userProfileImageView.image = // TODO: - 프로필 이미지 추가
        userNicknameLabel.text = data.nickname
        blocksNumberLabel.text = "\(data.score)"
        
        switch data.rank {
        case 1,2,3:
            markTop123(isOn: true)
        default:
            break
        }
        
        if(data.nickname == UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)) {
            markMyRanking(isOn: true)
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
