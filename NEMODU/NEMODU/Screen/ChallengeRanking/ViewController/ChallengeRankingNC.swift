//
//  ChallengeRankingNC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/22.
//

import UIKit

class ChallengeRankingNC: BaseNavigationController {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([ChallengeRankingVC()], animated: true)
    }
    
    // MARK: - Functions
    
}
