//
//  ChallengeRankingVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeRankingVC: BaseViewController {
    
    // MARK: - UI components
    
    let challengeRankingMenuBar = ChallengeRankingMenuBarCV()
        .then {
            $0.menuList = ["챌린지", "랭킹"]
        }
    
    let challengeRankingContainerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        .then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
            
            $0.backgroundColor = .white
            
            $0.isPagingEnabled = true
            $0.isScrollEnabled = false
            $0.showsHorizontalScrollIndicator = false
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        challengeRankingMenuBar.challengeRankingVC = self
        
        _ = challengeRankingContainerCollectionView
            .then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(ChallengeContainerCVC.self, forCellWithReuseIdentifier: ChallengeContainerCVC.className)
            $0.register(RankingContainerCVC.self, forCellWithReuseIdentifier: RankingContainerCVC.className)
        }
    }
    
    override func layoutView() {
        super.layoutView()
        
        view.addSubview(challengeRankingMenuBar)
        view.addSubview(challengeRankingContainerCollectionView)
        
        challengeRankingMenuBar.snp.makeConstraints {
            $0.height.equalTo(59)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalTo(view)
        }
        challengeRankingContainerCollectionView.snp.makeConstraints {
            $0.top.equalTo(challengeRankingMenuBar.snp.bottom)
            $0.horizontalEdges.equalTo(view)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
}

// MARK: - Challenge/Ranking CollectionView Delegate

extension ChallengeRankingVC : UICollectionViewDelegate { }

// MARK: - Challenge/Ranking CollectionView FlowLayout

extension ChallengeRankingVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }

}

// MARK: - Challenge/Ranking CollectionView DataSource

extension ChallengeRankingVC : UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        challengeRankingMenuBar.positionBarView.frame.origin.x = scrollView.contentOffset.x / CGFloat(challengeRankingMenuBar.menuList.count)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let menuIndex = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: menuIndex, section: 0)
        challengeRankingMenuBar.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challengeRankingMenuBar.menuList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId: String
        
        switch indexPath.item {
        case 0:
            cellId = ChallengeContainerCVC.className
        case 1:
            cellId = RankingContainerCVC.className
        default:
            cellId = BaseCollectionViewCell.className
        }
        
        
        let cell = challengeRankingContainerCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseCollectionViewCell
        
        return cell
    }
    
}
