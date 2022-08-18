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
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        positionBarView.removeFromSuperview()
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
        
        return CGSize(width: menuTitleSize.width + itemSpacing
                      , height: menuTitleSize.height + itemSpacing)
    }
    
}

extension ChallengeListTypeMenuBarCV {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: ChallengeListTypeMenuBarCVC.className, for: indexPath) as! ChallengeListTypeMenuBarCVC
        cell.menuTitle.text = menuList[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected : ", indexPath.item)
    }
    
}
