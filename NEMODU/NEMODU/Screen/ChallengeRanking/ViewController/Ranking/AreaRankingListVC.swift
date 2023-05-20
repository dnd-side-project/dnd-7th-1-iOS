//
//  AreaRankingListVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/18.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class AreaRankingListVC : RankingListVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    private let viewModel = AreaRankingListVM()
    private var areaRankingListResponseModel: AreaRankingListResponseModel?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindAreaRankingList()
    }
    
    // MARK: - Functions
    
    func configureRankingUserTVC() {
        guard let areaRankingList = areaRankingListResponseModel else { return }
        for areaRanking in areaRankingList.areaRankings {
            if areaRanking.nickname == myUserNickname {
                myRankingTVC.configureRankingCell(rankNumber: areaRanking.rank, profileImageURL: areaRanking.picturePathURL, nickname: areaRanking.nickname, blocksNumber: areaRanking.score)
                myRankingTVC.configureRankingTopCell()
            }
        }
    }
    
    override func configureWeeksNavigation(targetDate: Int) {
        super.configureWeeksNavigation(targetDate: targetDate)
        
        getAreaRankingList()
    }
    
    override func configureTableView() {
        _ = rankingTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(RankingUserTVC.self, forCellReuseIdentifier: RankingUserTVC.className)
                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
            }
    }
    
    func getAreaRankingList() {
        let dateList = makeDateByFormat()
        let startDate = dateList[0]
        let endDate = dateList[1]
        
        viewModel.getAreaRankingList(with: myUserNickname, started: startDate, ended: endDate)
    }
}

// MARK: - TableView DataSource

extension AreaRankingListVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC
        else { return UITableViewCell() }
        
        guard let areaRankingList = areaRankingListResponseModel else { return cell }
        let userAreaRanking = areaRankingList.areaRankings[indexPath.row]
        cell.configureRankingCell(rankNumber: userAreaRanking.rank, profileImageURL: userAreaRanking.picturePathURL, nickname: userAreaRanking.nickname, blocksNumber: userAreaRanking.score)
        cell.configureRankingListCell(rankNumber: userAreaRanking.rank, nickname: userAreaRanking.nickname)
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV
        footerView?.statusLabel.text = "랭킹 목록이 없습니다."

        return footerView
    }

}

// MARK: - TableView Delegate

extension AreaRankingListVC : UITableViewDelegate {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let fakeView = UIView()
            fakeView.backgroundColor = .white

            return fakeView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaRankingListResponseModel?.areaRankings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    // FooterView
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}

// MARK: - Output

extension AreaRankingListVC {
    private func bindAreaRankingList() {
        viewModel.output.areaRankings
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.areaRankingListResponseModel = data
                
                self.configureRankingUserTVC()
                self.rankingTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
