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
                myRankingTVC.markMyRankingTVC(rankNumber: areaRanking.rank, myNickname: areaRanking.nickname, blocksNumber: areaRanking.score)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'"
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDayNum = calendar.component(.weekday, from: selectedDate)
        
        let mondayNum = 2 - currentDayNum
        guard let mondayDate = calendar.date(byAdding: .day, value: mondayNum, to: selectedDate) else { return }
        var startDate = dateFormatter.string(from: mondayDate)
        startDate.append("00:00:00")
        
        let sundayNum = 8 - currentDayNum
        guard let sundayDate = calendar.date(byAdding: .day, value: sundayNum, to: selectedDate) else { return }
        var endDate = dateFormatter.string(from: sundayDate)
        endDate.append("23:59:59")
        
        viewModel.getAreaRankingList(with: RankingListRequestModel(end: endDate, nickname: myUserNickname, start: startDate))
    }
}

// MARK: - TableView DataSource

extension AreaRankingListVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC
        else { return UITableViewCell() }
        
        guard let areaRankingList = areaRankingListResponseModel else { return cell }
        cell.configureAreaRankingCell(with: areaRankingList.areaRankings[indexPath.row])
        
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
            .disposed(by: bag)
    }
}
