//
//  ProgressChallengeDetailVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ProgressChallengeDetailVC: ChallengeDetailVC {
    
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
                
                $0.register(ProgressChallengeDetailTVHV.self, forHeaderFooterViewReuseIdentifier: ProgressChallengeDetailTVHV.className)
                $0.register(RankingUserTVC.self, forCellReuseIdentifier: RankingUserTVC.className)
                $0.register(ChallengeDetailTVFV.self, forHeaderFooterViewReuseIdentifier: ChallengeDetailTVFV.className)
            }
    }
    
}

// MARK: - TableView DataSource

extension ProgressChallengeDetailVC : UITableViewDataSource {

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC else { return UITableViewCell() }
        
        return cell
    }

}

// MARK: - TableView Delegate

extension ProgressChallengeDetailVC : UITableViewDelegate {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProgressChallengeDetailTVHV.className) as? ProgressChallengeDetailTVHV else { return UITableViewHeaderFooterView() }
        
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
    
    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChallengeDetailTVFV.className) as? ChallengeDetailTVFV else { return UITableViewHeaderFooterView() }
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
