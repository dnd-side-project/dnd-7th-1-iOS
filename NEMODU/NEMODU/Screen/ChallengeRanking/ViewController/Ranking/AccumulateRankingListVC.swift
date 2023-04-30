//
//  AccumulateRankingListVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/18.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class AccumulateRankingListVC : RankingListVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    private let viewModel = AccumulateRankingListVM()
    private var accumulateRankingListResponseModel: AccumulateRankingListResponseModel?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getAccumulateRankingList(with: myUserNickname)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        weeksNavigationView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindAccumulateRankingList()
    }
    
    // MARK: - Functions
    
    func configureRankingUserTVC() {
        guard let accumulateRankingList = accumulateRankingListResponseModel else { return }
        for accumulateRanking in accumulateRankingList.matrixRankings {
            if accumulateRanking.nickname == myUserNickname {
                myRankingTVC.configureRankingCell(rankNumber: accumulateRanking.rank, profileImageURL: accumulateRanking.picturePathURL, nickname: accumulateRanking.nickname, blocksNumber: accumulateRanking.score)
                myRankingTVC.configureRankingTopCell()
            }
        }
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
    
}

// MARK: - TableView DataSource

extension AccumulateRankingListVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC
        else { return UITableViewCell() }
        
        guard let accumulateRankingList = accumulateRankingListResponseModel else { return cell }
        let userAccumulateRanking = accumulateRankingList.matrixRankings[indexPath.row]
        cell.configureRankingCell(rankNumber: userAccumulateRanking.rank, profileImageURL: userAccumulateRanking.picturePathURL, nickname: userAccumulateRanking.nickname, blocksNumber: userAccumulateRanking.score)
        cell.configureRankingListCell(rankNumber: userAccumulateRanking.rank, nickname: userAccumulateRanking.nickname)
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV
        footerView?.statusLabel.text = "랭킹 목록이 없습니다."

        return footerView
    }

}

// MARK: - TableView Delegate

extension AccumulateRankingListVC : UITableViewDelegate {
    
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
        return accumulateRankingListResponseModel?.matrixRankings.count ?? 0
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

extension AccumulateRankingListVC {
    private func bindAccumulateRankingList() {
        viewModel.output.accumulateRankings
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.accumulateRankingListResponseModel = data
                
                self.configureRankingUserTVC()
                self.rankingTableView.reloadData()
            })
            .disposed(by: bag)
    }
}
