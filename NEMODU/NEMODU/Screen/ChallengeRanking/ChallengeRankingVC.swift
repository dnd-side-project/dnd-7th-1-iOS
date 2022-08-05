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
    
    let menuBar = MenuBarCV()
        .then {
            $0.menuList = ["챌린지", "랭킹"]
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Helper
    
    override func configureView() {
        super.configureView()
        
        view.backgroundColor = .systemPink
    }
    
    override func layoutView() {
        super.layoutView()
        
        print("VC: layoutView")
        
        view.addSubview(menuBar)
        
        menuBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(59)
        }
    }
    
}
