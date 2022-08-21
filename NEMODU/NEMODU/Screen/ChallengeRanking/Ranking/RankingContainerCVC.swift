//
//  RankingContainerCVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/05.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class RankingContainerCVC : BaseCollectionViewCell {
    
    // MARK: - UI components
    
    let rankingListTypeMenuBar = RankingListTypeMenuBarCV()
        .then {
            $0.menuList = ["영역 랭킹", "걸음수 랭킹", "역대 누적 랭킹"]
            $0.menuBarCollectionView.backgroundColor = .white
        }
    
    let rankingTableView = UITableView(frame: .zero, style: .grouped)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
        }
    
    // MARK: - Variables and Properties
    
    var reloadRankingTypeIndex = 0
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    override func configureView() {
        super.configureView()
        
        rankingListTypeMenuBar.rankingContainerCVC = self
        
        _ = rankingTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                
                // headerView
                $0.register(RankingWeeksNavigationTVHV.self, forHeaderFooterViewReuseIdentifier: RankingWeeksNavigationTVHV.className)
                
                // cell
                $0.register(RankingUserTVC.self, forCellReuseIdentifier: RankingUserTVC.className)
                
                // footerView
                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
                
                
                // footerView 하단 여백이 생기는 것을 방지(tableView 내의 scrollView의 inset 값 때문인 것으로 추정)
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
            }
    }
    
    override func layoutView() {
        super.layoutView()
        
        contentView.addSubview(rankingListTypeMenuBar)
        contentView.addSubview(rankingTableView)
        
        
        rankingListTypeMenuBar.snp.makeConstraints {
            $0.height.equalTo(64)

            $0.top.equalTo(contentView.snp.top)
            $0.horizontalEdges.equalTo(contentView)
        }
        rankingTableView.snp.makeConstraints {
            $0.top.equalTo(rankingListTypeMenuBar.snp.bottom)
            $0.horizontalEdges.equalTo(rankingListTypeMenuBar)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}

// MARK: - RankingTableView Delegate

extension RankingContainerCVC : UITableViewDelegate { }

// MARK: - RankingTableView DataSource

extension RankingContainerCVC : UITableViewDataSource {

    // HeaderView
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if reloadRankingTypeIndex != 2 && section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RankingWeeksNavigationTVHV.className) as? RankingWeeksNavigationTVHV
            headerView?.rankingContainerCVC = self
            
            return headerView
        } else {
            let fakeView = UIView()
            fakeView.backgroundColor = .green

            return fakeView
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        reloadRankingTypeIndex != 2 && section == 0 ? UITableView.automaticDimension : .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        reloadRankingTypeIndex != 2 && section == 0 ? UITableView.automaticDimension : .leastNormalMagnitude
    }

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 1 ? 17 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as! RankingUserTVC
        
        switch indexPath.section {
        case 1:
            // 걸음수 랭킹 설정
            if reloadRankingTypeIndex == 1 {
                cell.blockLabel.text = "걸음"
            }
            
            // 내 기록 표시 설정
            let ranking = indexPath.row + 1
            let userRankIndex = 2
            if userRankIndex == ranking {
                cell.markMyRankingCell()
                cell.rankNumberLabel.text = String(userRankIndex)
            } else {
                cell.rankNumberLabel.text = String(ranking)
            }
            
            // 1, 2, 3등 표시 설정
            switch ranking {
            case 1, 2, 3:
                cell.rankNumberLabel.textColor = .main
            default:
                break
            }
        default:
            break
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("rankingTV row selected ", indexPath.row)
    }

    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV
        footerView?.statusLabel.text = "랭킹 목록이 없습니다."

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == 1 ? 93 : .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        section == 1 ? 93 : .leastNormalMagnitude
    }

}
