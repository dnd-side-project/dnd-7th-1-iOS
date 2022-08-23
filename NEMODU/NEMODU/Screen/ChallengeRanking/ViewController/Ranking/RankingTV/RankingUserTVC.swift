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
    
    let contentsView = UIView()
        .then {
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.clear.cgColor
        }
    
    let rankNumberLabel = UILabel()
        .then {
            $0.font = .headline1
            $0.textColor = .gray700
            $0.backgroundColor = .clear
            $0.textAlignment = .center
        }
    let userProfileImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "defaultThumbnail")
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
        }
    let showMeLabel = UILabel()
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
    let userNicknameLabel = UILabel()
        .then {
            $0.text = "-"
            $0.font = .body1
            $0.textColor = .gray900
        }
    let blocksNumberLabel = UILabel()
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // remove nickname
        userNicknameLabel.text = ""
        
        // remove 걸음수 랭킹 - '걸음'
        blockLabel.text = "칸"
        
        // remove 칸, 걸음 개수
        blocksNumberLabel.text = ""
        
        // remove mrakMyRanking status
        _ = contentsView
            .then {
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.layer.backgroundColor = UIColor.gray50.cgColor
            }
        showMeLabel.isHidden = true
        
        // remove 1, 2, 3 ranker
        rankNumberLabel.textColor = .gray700
    }
    
    // MARK: - Function
    
    override func configureView() {
        super.configureView()
        
        selectionStyle = .none
    }
    
    override func layoutView() {
        super.layoutView()
        
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
            $0.left.lessThanOrEqualTo(userNicknameLabel.snp.right) // TODO: - 닉네임과 칸 수의 영역 침범 가능성을 검토해야 함
        }
        blockLabel.snp.makeConstraints {
            $0.centerY.equalTo(blocksNumberLabel)
            $0.left.equalTo(blocksNumberLabel.snp.right).offset(4)
            $0.right.equalTo(contentsView.snp.right).inset(24)
        }
    }
    
    func markMyRankingCell() {
        _ = contentsView
            .then {
                $0.layer.borderColor = UIColor.main.cgColor
                $0.layer.backgroundColor = UIColor.main.withAlphaComponent(0.1).cgColor
            }
        showMeLabel.isHidden = false
    }
    
    // MARK: - configure TVC acording to Ranking Type
    
    func configureAreaRankingCell(with data: AreaRanking) {
        // TODO: - 서버 연결 후 프로필 이미지 추가
//        userProfileImageView.image =
        userNicknameLabel.text = data.nickname
        blocksNumberLabel.text = "\(data.score)"
        rankNumberLabel.text = "\(data.rank)"
    }
    
    func configureStepRankingCell(with data: StepRanking) {
        // TODO: - 서버 연결 후 프로필 이미지 추가
//        userProfileImageView.image =
        userNicknameLabel.text = data.nickname
        blocksNumberLabel.text = "\(data.score)"
        rankNumberLabel.text = "\(data.rank)"
    }
    
    func configureAccumulateRankingCell(with data: MatrixRanking) {
        // TODO: - 서버 연결 후 프로필 이미지 추가
//        userProfileImageView.image =
        userNicknameLabel.text = data.nickname
        blocksNumberLabel.text = "\(data.score)"
        rankNumberLabel.text = "\(data.rank)"
    }
}
