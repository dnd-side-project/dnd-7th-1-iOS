//
//  ChallengeListTypeMenuBarCV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/20.
//

import UIKit

class ChallengeListTypeMenuBarCV : ListTypeMenuBarCV {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    var challengeContainerCVC: ChallengeContainerCVC?
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        _ = menuBarCollectionView.then {
            // 선택되어 있는 위치 지정
            let indexPath = IndexPath(item: challengeContainerCVC?.reloadCellIndex ?? 0, section: 0)
            $0.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
    }
    
    // MARK: - Function
}

// MARK: - ChallengeListType MenuBar CollectionView

extension ChallengeListTypeMenuBarCV {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ChallengeType selected : ", indexPath.item)
        
        let targetItemIndex = indexPath.item
        let currentItemIndex = challengeContainerCVC?.reloadCellIndex ?? 0
        
        challengeContainerCVC?.reloadCellIndex = targetItemIndex
        if targetItemIndex != currentItemIndex {
            challengeContainerCVC?.challengeTableView.reloadSections(IndexSet(2...2), with: targetItemIndex > currentItemIndex ? .left : .right)
        }
    }
    
}
