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
    
    let positionBarHeight: CGFloat = 1.0
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        positionBarView.snp.makeConstraints {
            $0.height.equalTo(positionBarHeight)
        }
        
        
        // 랭킹탭 개발을 위한 임시코드 //
        let indexPath = IndexPath(row: 1, section: 0)
        
        _ = menuBarCollectionView.then {
            // 최초 실행 시 선택되어 있는 위치 지정
            $0.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        challengeRankingVC?.challengeRankingContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        // 랭킹탭 개발을 위한 임시코드 //
        
    }
    
    // MARK: - Function
    
    override func configureView() {
        // register ChallengeRankingMenuBarCVC
        menuBarCollectionView.register(ChallengeRankingMenuBarCVC.self, forCellWithReuseIdentifier: ChallengeRankingMenuBarCVC.className)
        
        menuBarCollectionView.delegate = self
        menuBarCollectionView.dataSource = self
    }
    
    override func layoutView() {
        super.layoutView()
        
        addSubview(borderLine)
        borderLine.snp.makeConstraints {
            $0.height.equalTo(positionBarHeight)
            
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - ChallengeRanking MenuBar CollectionView

extension ChallengeRankingMenuBarCV {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: ChallengeRankingMenuBarCVC.className, for: indexPath) as! ChallengeRankingMenuBarCVC
        cell.menuTitle.text = menuList[indexPath.item]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        challengeRankingVC?.challengeRankingContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}
