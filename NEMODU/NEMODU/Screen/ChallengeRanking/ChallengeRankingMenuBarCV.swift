//
//  ChallengeRankingMenuBarCV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit

class ChallengeRankingMenuBarCV : MenuBarCV {
    
    // MARK: - UI components
    
    let borderLine = UIView()
        .then {
            $0.backgroundColor = .lightGray
        }
    
    // MARK: - Variables and Properties
    
    var challengeRankingVC: ChallengeRankingVC?
    
    let positionBarHeight: CGFloat = 2.0
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        positionBarView.snp.makeConstraints {
            $0.height.equalTo(positionBarHeight)
        }
    }
    
    // MARK: - Function
    
    override func layoutView() {
        super.layoutView()
        
        addSubview(borderLine)
        borderLine.snp.makeConstraints {
            $0.height.equalTo(positionBarHeight)
            
            $0.left.equalTo(self.snp.left)
            $0.right.equalTo(self.snp.right)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }
    
}

// MARK: - ChallengeRanking MenuBar CollectionView

extension ChallengeRankingMenuBarCV {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        challengeRankingVC?.challengeRankingContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}
