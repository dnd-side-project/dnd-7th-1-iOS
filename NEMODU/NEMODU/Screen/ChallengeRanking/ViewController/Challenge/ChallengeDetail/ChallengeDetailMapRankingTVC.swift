//
//  ChallengeDetailMapRankingTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/18.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class ChallengeDetailMapRankingTVC: BaseTableViewCell {
    private let rankLabel = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray700
        }
    
    private let profileImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.layer.cornerRadius = CGFloat(ChallengeDetailMapRankingTVC.profileImageSize / 2)
            $0.layer.borderWidth = 2
            $0.clipsToBounds = true
        }
    
    private lazy var meLabel = UILabel()
        .then {
            $0.text = "나"
            $0.textColor = .white
            $0.backgroundColor = .secondary
            $0.textAlignment = .center
            $0.font = .PretendardRegular(size: 10)
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
        }
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 2
        }
    
    private let nicknameLabel = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray700
            $0.textAlignment = .left
        }
    
    private let blocksCountLabel = UILabel()
        .then {
            $0.font = .title3M
            $0.textColor = .gray900
            $0.textAlignment = .left
        }
    
    static let profileImageSize = 40
    typealias Location = (latitude: Double?, longitude: Double?)
    private var location: Location?
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankLabel.text = "-위"
        profileImageView.image = .defaultThumbnail
        nicknameLabel.text = nil
        blocksCountLabel.text = nil
    }
}

// MARK: - Configure

extension ChallengeDetailMapRankingTVC {
    private func configureContentView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubviews([rankLabel,
                     profileImageView,
                     baseStackView])
        
        [nicknameLabel, blocksCountLabel].forEach {
            baseStackView.addArrangedSubview($0)
        }
    }
    
    func configureCell(rank: RankingList, matrix: MatrixList) {
        rankLabel.text = "\(rank.rank)위"
        profileImageView.kf.setImage(with: rank.picturePathURL)
        profileImageView.layer.borderColor = ChallengeColorType(rawValue: matrix.color)?.primaryColor.cgColor
        nicknameLabel.text = "\(rank.nickname)"
        blocksCountLabel.text = "\(rank.score)칸"
        
        self.location = (matrix.latitude, matrix.longitude)
        
        if let myNickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname),
           myNickname == rank.nickname {
            meLabelLayout()
        }
    }
    
    /// cell에 저장된 loaction을 반환하는 메서드
    func getLocation() -> Location? {
        return location
    }
}

// MARK: - Layout

extension ChallengeDetailMapRankingTVC {
    private func configureLayout() {
        rankLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(ChallengeDetailMapRankingTVC.profileImageSize)
        }
        
        baseStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
    }
    
    private func meLabelLayout() {
        addSubview(meLabel)
        
        meLabel.snp.makeConstraints {
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.width.height.equalTo(16)
        }
    }
}
