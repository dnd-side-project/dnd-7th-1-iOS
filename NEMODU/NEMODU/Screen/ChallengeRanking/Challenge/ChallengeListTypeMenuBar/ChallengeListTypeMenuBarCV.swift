//
//  ChallengeListTypeMenuBarCV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/18.
//

import UIKit

class ChallengeListTypeMenuBarCV : MenuBarCV {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    let itemSpacing: CGFloat = 10
    
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
    
    override func configureView() {
        // resetting layout collectionView
        _ = menuBarCollectionView
            .then {
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                layout.minimumLineSpacing = 12 - itemSpacing
                layout.minimumInteritemSpacing = 12 - itemSpacing
                
                $0.collectionViewLayout = layout
                
                $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        
        // register ChallengeRankingMenuBarCVC
        menuBarCollectionView.register(ChallengeListTypeMenuBarCVC.self, forCellWithReuseIdentifier: ChallengeListTypeMenuBarCVC.className)
        
        menuBarCollectionView.delegate = self
        menuBarCollectionView.dataSource = self
    }
    
}

// MARK: - ChallengeListType MenuBar CollectionView

extension ChallengeListTypeMenuBarCV {
    
    override func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuTitleSize = menuList[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.title3SB])
        
        return CGSize(width: menuTitleSize.width + itemSpacing,
                      height: menuTitleSize.height + itemSpacing)
    }
    
}

extension ChallengeListTypeMenuBarCV {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: ChallengeListTypeMenuBarCVC.className, for: indexPath) as! ChallengeListTypeMenuBarCVC
        cell.menuTitle.text = menuList[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ChallengeType selected : ", indexPath.item)
        
        let targetItemIndex = indexPath.item
        let currentItemIndex = challengeContainerCVC?.reloadCellIndex ?? 0
        let targetReloadSection = IndexSet(2...2)
        
        challengeContainerCVC?.reloadCellIndex = targetItemIndex
        
        if targetItemIndex == currentItemIndex {
            // do nothing
        } else {
            if targetItemIndex > currentItemIndex {
                challengeContainerCVC?.challengeTableView.reloadSections(targetReloadSection, with: .left)
            } else {
                challengeContainerCVC?.challengeTableView.reloadSections(targetReloadSection, with: .right)
            }
        }
    }
    
}
