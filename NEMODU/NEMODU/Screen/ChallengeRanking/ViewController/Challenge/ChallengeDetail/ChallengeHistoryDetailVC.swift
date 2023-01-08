//
//  ChallengeHistoryDetailVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeHistoryDetailVC: ChallengeDetailVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    private let viewModel = ChallengeHistoryDetailVM()
    private let bag = DisposeBag()
    var challengeHistoryDetailResponseModel: ChallengeHistoryDetailResponseModel?
    
    var challgeStatus: String?
    
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
    
    override func bindOutput() {
        super.bindOutput()
        
        bindChallengeHistoryDetail()
    }
    
    // MARK: - Functions
    
    func getChallengeHistoryDetailInfo(uuid: String) {
        let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""
        viewModel.getChallengeHistoryDetail(nickname: nickname, uuid: uuid)
    }
    
    override func configureTableView() {
        super.configureTableView()
        
        _ = challengeDetailTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(ChallengeHistoryDetailTVHV.self, forHeaderFooterViewReuseIdentifier: ChallengeHistoryDetailTVHV.className)
                $0.register(RankingUserTVC.self, forCellReuseIdentifier: RankingUserTVC.className)
                $0.register(ChallengeDetailTVFV.self, forHeaderFooterViewReuseIdentifier: ChallengeDetailTVFV.className)
            }
    }
    
}

// MARK: - TableView DataSource

extension ChallengeHistoryDetailVC : UITableViewDataSource {

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeHistoryDetailResponseModel?.rankings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC else { return UITableViewCell() }
        
        guard let challengeHistoryDetailInfo = challengeHistoryDetailResponseModel else { return cell }
        let userRankingInfo = challengeHistoryDetailInfo.rankings[indexPath.row]
        cell.configureRankingCell(rankNumber: userRankingInfo.rank, profileImageURL: userRankingInfo.picturePath, nickname: userRankingInfo.nickname, blocksNumber: userRankingInfo.score)
        cell.configureChallengeDetailRankingCell(nickname: userRankingInfo.nickname)
        
        return cell
    }

}

// MARK: - TableView Delegate

extension ChallengeHistoryDetailVC : UITableViewDelegate {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChallengeHistoryDetailTVHV.className) as? ChallengeHistoryDetailTVHV else { return UITableViewHeaderFooterView() }
        headerView.challengeHistoryDetailVC = self
        if challgeStatus == "Done" {
            headerView.configureChallengeDoneLayout()
        }
        
        guard let challengeHistoryDetailInfo = challengeHistoryDetailResponseModel else { return headerView }
        headerView.configureChallengeHistoryDetailTVHV(challengeHistoryDetailInfo: challengeHistoryDetailInfo)
        
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
        return 84
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChallengeDetailTVFV.className) as? ChallengeDetailTVFV else { return UITableViewHeaderFooterView() }

        guard let challengeHistoryDetailInfo = challengeHistoryDetailResponseModel else { return footerView }
        footerView.configureChallengeDetailTVFV(distance: challengeHistoryDetailInfo.distance, time: challengeHistoryDetailInfo.exerciseTime, steps: challengeHistoryDetailInfo.stepCount)

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - Output

extension ChallengeHistoryDetailVC {
    private func bindChallengeHistoryDetail() {
        viewModel.output.challengeHistoryDetail
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.challengeHistoryDetailResponseModel = data
                self.challengeDetailTableView.reloadData()
            })
            .disposed(by: bag)
    }
}
