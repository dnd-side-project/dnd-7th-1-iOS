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

class InvitedChallengeDetailVC: ChallengeDetailVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
    }
    
    override func layoutView() {
        super.layoutView()
        
    }
    
    // MARK: - Functions
    
    override func configureTableView() {
        super.configureTableView()
        
        _ = challengeDetailTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(InvitedChallengeDetailTVHV.self, forHeaderFooterViewReuseIdentifier: InvitedChallengeDetailTVHV.className)
                $0.register(InvitedFriendsTVC.self, forCellReuseIdentifier: InvitedFriendsTVC.className)
                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
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
