//
//  InvitedChallengeDetailVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/31.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class InvitedChallengeDetailVC: BaseViewController {
    
    // MARK: - UI components
    
    let navigationBar = NavigationBar()
        .then {
            $0.naviType = .push
            $0.setTitleFont(font: .title3M)
        }
    
    let invitedChallengeDetailTableView = UITableView(frame: .zero, style: .grouped)
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
    
}

// MARK: - Configure

extension InvitedChallengeDetailVC {
    
    private func configureNavigationBar() {
        _ = navigationBar
            .then {
                $0.configureNaviBar(targetVC: self, title: "챌린지 상세정보")
                $0.configureBackBtn(targetVC: self)
            }
    }
    
    private func configureTableView() {
        _ = invitedChallengeDetailTableView
            .then {
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
                
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(InvitedChallengeDetailTVHV.self, forHeaderFooterViewReuseIdentifier: InvitedChallengeDetailTVHV.className)
                $0.register(InvitedFriendsTVC.self, forCellReuseIdentifier: InvitedFriendsTVC.className)
                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
            }
    }
    
}

// MARK: - Layout

extension InvitedChallengeDetailVC {
    
    private func configureLayout() {
        view.addSubviews([navigationBar, invitedChallengeDetailTableView])
        
        invitedChallengeDetailTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
    }
    
}

// MARK: - TableView DataSource

extension InvitedChallengeDetailVC : UITableViewDataSource {

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InvitedFriendsTVC.className, for: indexPath) as? InvitedFriendsTVC else { return UITableViewCell() }
        
        return cell
    }

}

// MARK: - TableView Delegate

extension InvitedChallengeDetailVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: InvitedChallengeDetailTVHV.className) as? InvitedChallengeDetailTVHV
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    // Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}
