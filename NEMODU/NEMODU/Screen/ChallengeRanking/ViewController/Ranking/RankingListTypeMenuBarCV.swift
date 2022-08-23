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
        let targetItemIndex = indexPath.item
        let currentItemIndex = rankingContainerCVC?.reloadRankingTypeIndex ?? 0

        rankingContainerCVC?.reloadRankingTypeIndex = targetItemIndex
        if targetItemIndex != currentItemIndex {
            
            switch targetItemIndex {
            case 0:
                if rankingContainerCVC?.areaRankings == nil {
                    rankingContainerCVC?.viewModel.getAreaRankingList(with: RankingListRequestModel(end: "2022-08-18T23:59:59",
                                                                                   nickname: "NickA",
                                                                                   start: "2022-08-15T00:00:00"))
                    rankingContainerCVC?.bindAreaRankingTableView()
                }
            case 1:
                if rankingContainerCVC?.stepRankings == nil {
                    rankingContainerCVC?.viewModel.getStepRankingList(with: RankingListRequestModel(end: "2022-08-18T23:59:59",
                                                                                   nickname: "NickA",
                                                                                   start: "2022-08-15T00:00:00"))
                    rankingContainerCVC?.bindStepRankingTableView()
                }
            case 2:
                if rankingContainerCVC?.accumulateRankings == nil {
                    rankingContainerCVC?.viewModel.getAccumulateRankingList(with: "NickA")
                    rankingContainerCVC?.bindAccumulateRankingTableView()
                }
            default:
                break
            }
            
            rankingContainerCVC?.rankingTableView.reloadSections(IndexSet(1...1), with: .fade)
            rankingContainerCVC?.rankingTableView.scrollToRow(at: IndexPath(row: NSNotFound, section: 0), at: .top, animated: true)
        }
    }
}
