//
//  NEMODUTBC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/29.
//

import UIKit

class NEMODUTBC: UITabBarController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        setStartTabIndex(index: 1)
    }
    
}

// MARK: - NEMODU TabBarController

extension NEMODUTBC {
    
    private func setTabBar() {
        // 탭바 스타일 설정
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        tabBar.tintColor = .main
        tabBar.unselectedItemTintColor = .gray300
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 0.3
        
        // 탭 구성
        let challengeRankingTab = makeTabVC(vc: ChallengeRankingNC(), tabBarTitle: "챌린지/랭킹", tabBarImage: "TabBarIcon/challengeRanking" , tabBarSelectedImage: "TabBarIcon/challengeRanking_fill")
        let mapTab = makeTabVC(vc: MainVC(), tabBarTitle: "지도", tabBarImage: "TabBarIcon/map", tabBarSelectedImage: "TabBarIcon/map_fill")
        let mypageTab = makeTabVC(vc: MypageNC(), tabBarTitle: "MY", tabBarImage: "TabBarIcon/mypage", tabBarSelectedImage: "TabBarIcon/mypage_fill")
        
        let tabs =  [challengeRankingTab, mapTab, mypageTab]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
    
    /// tabBar의 선택된 탭을 지정하는 함수
    func setStartTabIndex(index: Int) {
        self.selectedIndex = index
    }
    
    private func makeTabVC(vc: UIViewController, tabBarTitle: String, tabBarImage: String, tabBarSelectedImage: String) -> UIViewController {
        let tab = vc
        tab.tabBarItem = UITabBarItem(title: tabBarTitle, image: UIImage(named: tabBarImage)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: tabBarSelectedImage)?.withRenderingMode(.alwaysOriginal))
        tab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -0.5)
        
        return tab
    }
    
    
}
