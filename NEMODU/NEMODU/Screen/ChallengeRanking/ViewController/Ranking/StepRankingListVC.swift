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
    
    private let viewModel = StepRankingListVM()
    private var stepRankingListResponseModel: StepRankingListResponseModel?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindStepRankingList()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindAPIErrorAlert(viewModel)
    }
    
    // MARK: - Functions
    
    func configureRankingUserTVC() {
        guard let stepRankingList = stepRankingListResponseModel else { return }
        for stepRanking in stepRankingList.stepRankings {
            if stepRanking.nickname == myUserNickname {
                myRankingView.configureRankingUserView(rankNumber: stepRanking.rank, profileImageURL: stepRanking.picturePathURL, nickname: stepRanking.nickname, blocksNumber: stepRanking.score)
                myRankingView.configureRankingTop()
                myRankingView.configureStepRanking()
            }
        }
    }
    
    override func configureWeeksNavigation(targetDate: Int) {
        super.configureWeeksNavigation(targetDate: targetDate)
        
        getStepRankingList()
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
    
    func getStepRankingList() {
        let dateList = makeDateByFormat()
        let startDate = dateList[0]
        let endDate = dateList[1]
        
        viewModel.getStepRankingList(with: myUserNickname, started: startDate, ended: endDate)
    }
}

// MARK: - TableView DataSource

extension StepRankingListVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC
        else { return UITableViewCell() }
        
        guard let stepRankingList = stepRankingListResponseModel else { return cell }
        let userStepRanking = stepRankingList.stepRankings[indexPath.row]
        cell.configureRankingCell(rankNumber: userStepRanking.rank, profileImageURL: userStepRanking.picturePathURL, nickname: userStepRanking.nickname, blocksNumber: userStepRanking.score)
        cell.configureRankingListCell(rankNumber: userStepRanking.rank, nickname: userStepRanking.nickname)
        cell.configureStepRankingCell()
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV
        footerView?.statusLabel.text = "랭킹 목록이 없습니다."

        return footerView
    }

}

// MARK: - TableView Delegate

extension StepRankingListVC : UITableViewDelegate {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let fakeView = UIView()
            fakeView.backgroundColor = .white

            return fakeView
    }

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepRankingListResponseModel?.stepRankings.count ?? 0
    }
    
}

// MARK: - Output

extension StepRankingListVC {
    private func bindStepRankingList() {
        viewModel.output.stepRankings
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.stepRankingListResponseModel = data
                
                self.configureRankingUserTVC()
                self.rankingTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
