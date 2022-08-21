//
//  RankingListTypeMenuBarCV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/20.
//

import UIKit

class RankingListTypeMenuBarCV : ListTypeMenuBarCV {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    var rankingContainerCVC: RankingContainerCVC?
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Function
}

// MARK: - RankingListType MenuBar CollectionView

extension RankingListTypeMenuBarCV {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("RankingType selected : ", indexPath.item)
        
        let targetItemIndex = indexPath.item
        let currentItemIndex = rankingContainerCVC?.reloadRankingTypeIndex ?? 0

        rankingContainerCVC?.reloadRankingTypeIndex = targetItemIndex
        if targetItemIndex != currentItemIndex {
            rankingContainerCVC?.rankingTableView.reloadSections(IndexSet(1...1), with: .fade)
            rankingContainerCVC?.rankingTableView.scrollToRow(at: IndexPath(row: NSNotFound, section: 0), at: .top, animated: true)
        }
    }
    
}
