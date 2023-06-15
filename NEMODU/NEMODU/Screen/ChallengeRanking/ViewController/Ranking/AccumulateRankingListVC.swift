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
    private var cntAccumulateRankingList = 0
    private var isLast = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAccumulateRankingData()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindMyAccumulateRanking()
        bindAccumulateRankingList()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindAPIErrorAlert(viewModel)
    }
    
    override func configureWeeksNavigation(targetDate: Int) {
        weeksNavigationView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        weeksNavigationView.isHidden = true
    }
    
    // MARK: - Functions
    
    func getAccumulateRankingData() {
        accumulateRankingListResponseModel = nil
        isLast = false
        cntAccumulateRankingList = 0
        viewModel.getMyAccumulateRanking(nickname: myUserNickname)
        viewModel.getAccumulateRankingList(offset: cntAccumulateRankingList + 1)
    }
    
    func configureRankingUserTVC(myAccumulateRanking: MatrixRanking) {
        myRankingView.configureRankingUserView(rankNumber: myAccumulateRanking.rank, profileImageURL: myAccumulateRanking.picturePathURL, nickname: myAccumulateRanking.nickname, blocksNumber: myAccumulateRanking.score)
        myRankingView.configureRankingTop()
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

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accumulateRankingListResponseModel?.matrixRankings.count ?? 0
    }
    
}

// MARK: - Output

extension AccumulateRankingListVC {
    private func bindMyAccumulateRanking() {
        viewModel.output.myAccumulateRanking
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.configureRankingUserTVC(myAccumulateRanking: data)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAccumulateRankingList() {
        viewModel.output.accumulateRankings
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                if self.accumulateRankingListResponseModel == nil {
                    self.accumulateRankingListResponseModel = data
                    self.cntAccumulateRankingList = self.accumulateRankingListResponseModel?.matrixRankings.count ?? 0
                } else {
                    self.accumulateRankingListResponseModel?.matrixRankings.append(contentsOf: data.matrixRankings)
                    let responseDataList = data.matrixRankings.count
                    self.isLast = responseDataList == 0 ? true : false
                    self.cntAccumulateRankingList += responseDataList
                }
                
                self.rankingTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        rankingTableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else { return }
                
                if let cntRankingList = self.accumulateRankingListResponseModel?.matrixRankings.count {
                    let lastIndex = cntRankingList - 1
                    if(lastIndex == indexPath.row &&
                       self.isLast == false) {
                        self.viewModel.getAccumulateRankingList(offset: cntRankingList + 1)
                    }                    
                }
            })
            .disposed(by: disposeBag)
    }
}
