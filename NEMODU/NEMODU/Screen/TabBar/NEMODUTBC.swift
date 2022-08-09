//
//  NEMODUTBC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/29.
//

import UIKit

class NEMODUTBC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setTabIndex(index: 1)
    }
}

extension NEMODUTBC {
    private func makeTabVC(vc: UIViewController, tabBarTitle: String, tabBarImage: String, tabBarSelectedImage: String) -> UIViewController {
        
        let tab = vc
        tab.tabBarItem = UITabBarItem(title: tabBarTitle, image: UIImage(named: tabBarImage), selectedImage: UIImage(named: tabBarSelectedImage))
        tab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -0.5)
        return tab
    }
    
    private func setTabBar() {
        let challengeTab = makeTabVC(vc: ChallengeVC(), tabBarTitle: "랭킹/챌린지", tabBarImage: "", tabBarSelectedImage: "")
        let mapTab = makeTabVC(vc: MainVC(), tabBarTitle: "지도", tabBarImage: "", tabBarSelectedImage: "")
        let mypageTab = makeTabVC(vc: MypageVC(), tabBarTitle: "MY", tabBarImage: "", tabBarSelectedImage: "")
        
        // 탭바 스타일 설정
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 0.3
        
        // 탭 구성
        let tabs =  [challengeTab, mapTab, mypageTab]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
    
    /// tabBar의 선택된 탭을 지정하는 함수
    func setTabIndex(index: Int) {
        self.selectedIndex = index
    }
}
