//
//  StepRankingListVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/18.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class StepRankingListVC : RankingListVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func configureRankingUserTVC() {
        super.configureRankingUserTVC()
        
        myRankingTVC.blockLabel.text = "걸음"
    }
    
}

// MARK: - TableView DataSource

extension StepRankingListVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC
        else { return UITableViewCell() }
        
        let ranking = indexPath.row + 1
        
        cell.configureCell(ranking: ranking)
        cell.blockLabel.text = "걸음"
        
        switch ranking {
        case 1,2,3:
            cell.markTop123(isOn: true)
        case 5:
            cell.markMyRanking(isOn: true)
        default:
            break
        }
        
        return cell
    }
    
}
