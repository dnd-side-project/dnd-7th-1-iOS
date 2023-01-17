//
//  ChallengeDetailVC.swift
//  NEMODU
//
//  Created by Kim Hee Jae on 2022/11/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeDetailVC: BaseViewController {
    
    // MARK: - UI components
    
    let navigationBar = NavigationBar()
        .then {
            $0.naviType = .push
            $0.setTitleFont(font: .title3M)
        }
    
    let challengeDetailTableView = UITableView(frame: .zero, style: .grouped)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
        configureTableView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
    func configureTableView() {
        _ = challengeDetailTableView
            .then {
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
            }
    }
    
}

// MARK: - Configure

extension ChallengeDetailVC {
    
    private func configureNavigationBar() {
        _ = navigationBar
            .then {
                $0.configureNaviBar(targetVC: self, title: "챌린지 상세정보")
                $0.configureBackBtn(targetVC: self)
            }
    }
    
}

// MARK: - Layout

extension ChallengeDetailVC {
    
    private func configureLayout() {
        view.addSubviews([navigationBar, challengeDetailTableView])
        
        challengeDetailTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
    }
    
}
