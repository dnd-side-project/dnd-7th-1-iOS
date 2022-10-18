//
//  ListTypeMenuBarCV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/18.
//

import UIKit

class ListTypeMenuBarCV : MenuBarCV {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    let itemSpacing: CGFloat = 10
    
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func configureCollectionView() {
        // resetting collectionView layout
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
        menuBarCollectionView.register(ListTypeMenuBarCVC.self, forCellWithReuseIdentifier: ListTypeMenuBarCVC.className)
        
        menuBarCollectionView.delegate = self
        menuBarCollectionView.dataSource = self
    }
}

// MARK: - CollectionView DataSource

extension ListTypeMenuBarCV {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: ListTypeMenuBarCVC.className, for: indexPath) as? ListTypeMenuBarCVC
        else { return UICollectionViewCell() }
        
        cell.menuTitle.text = menuList[indexPath.item]
        
        return cell
    }
    
}

// MARK: - CollectionView Delegate

extension ListTypeMenuBarCV {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // override to custom item selected action
    }
    
}

// MARK: - CollectionView FlowLayout

extension ListTypeMenuBarCV {
    
    override func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuTitleSize = menuList[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.title3SB])
        
        return CGSize(width: menuTitleSize.width + itemSpacing,
                      height: menuTitleSize.height + itemSpacing)
    }
    
}
