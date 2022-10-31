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
    
    var challengeContainerCVC: ChallengeVC?
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        // 최초 실행시 선택되어 있는 위치 지정
        _ = menuBarCollectionView.then {
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
        
        challengeContainerCVC?.bindChallengeList(index: indexPath.item)
    }
    
}
