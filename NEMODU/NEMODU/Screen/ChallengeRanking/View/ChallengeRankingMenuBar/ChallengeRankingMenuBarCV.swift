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
    
    let positionBarHeight: CGFloat = 1.0
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        positionBarView.snp.makeConstraints {
            $0.height.equalTo(positionBarHeight)
        }
    }
    
    // MARK: - Functions
    
    override func configureCollectionView() {
        menuBarCollectionView.register(ChallengeRankingMenuBarCVC.self, forCellWithReuseIdentifier: ChallengeRankingMenuBarCVC.className)
        
        menuBarCollectionView.delegate = self
        menuBarCollectionView.dataSource = self
    }
    
    override func configreLayout() {
        super.configreLayout()
        
        addSubview(borderLine)
        borderLine.snp.makeConstraints {
            $0.height.equalTo(positionBarHeight)
            
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - CollectionView Delegate

extension ChallengeRankingMenuBarCV {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: ChallengeRankingMenuBarCVC.className, for: indexPath) as! ChallengeRankingMenuBarCVC
        cell.menuTitle.text = menuList[indexPath.item]

        return cell
    }
    
}
