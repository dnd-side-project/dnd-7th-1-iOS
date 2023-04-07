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
    
    private let viewModel = InvitedChallengeDetailVM()
    private let bag = DisposeBag()
    
    var uuid: String = ""
    var invitedChallengeDetailResponseModel: InvitedChallengeDetailResponseModel?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
        configureTableView()
    }
    
    override func layoutView() {
        super.layoutView()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindInvitedChallengeDetail()
        responseAcceptChallengeSuccess()
        responseRejectChallengeSuccess()
    }
    
    // MARK: - Functions
    
    /// 서버에 초대받은 챌린지 상세정보 요청하는 함수
    func getInvitedChallengeDetailInfo() {
        let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""
        viewModel.getInvitedChallengeDetail(nickname: nickname, uuid: uuid)
    }
    
    private func configureTableView() {
        _ = challengeDetailTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(InvitedChallengeDetailTVHV.self, forHeaderFooterViewReuseIdentifier: InvitedChallengeDetailTVHV.className)
                $0.register(InvitedFriendsTVC.self, forCellReuseIdentifier: InvitedFriendsTVC.className)
                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
            }
    }
    
    func didTapAcceptButton() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        viewModel.requestAcceptChallenge(with: AcceptRejectChallengeRequestModel(nickname: nickname, uuid: uuid))
    }
    
    func didTapRejectButton() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        viewModel.requestRejectChallenge(with: AcceptRejectChallengeRequestModel(nickname: nickname, uuid: uuid))
    }
    
}

// MARK: - TableView DataSource

extension InvitedChallengeDetailVC : UITableViewDataSource {

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedChallengeDetailResponseModel?.infos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InvitedFriendsTVC.className, for: indexPath) as? InvitedFriendsTVC else { return UITableViewCell() }
        guard let invitedChallengeDetailInfo = invitedChallengeDetailResponseModel else { return cell }
        let invitedUserInfo = invitedChallengeDetailInfo.infos[indexPath.row]
        cell.configureInvitedFriendsTVC(userProfileImageURL: invitedUserInfo.picturePathURL, nickname: invitedUserInfo.nickname, status: invitedUserInfo.status)
        
        return cell
    }

}

// MARK: - TableView Delegate

extension InvitedChallengeDetailVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: InvitedChallengeDetailTVHV.className) as? InvitedChallengeDetailTVHV else { return UITableViewHeaderFooterView() }
        guard let invitedChallengeDetailInfo = invitedChallengeDetailResponseModel else { return headerView }
        headerView.configureInvitedChallengeDetailTVHV(invitedChallengeDetailInfo: invitedChallengeDetailInfo)
        headerView.invitedChallengeDetailVC = self
        
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

// MARK: - Output

extension InvitedChallengeDetailVC {
    
    private func bindInvitedChallengeDetail() {
        viewModel.output.invitedChallengeDetail
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.invitedChallengeDetailResponseModel = data
                self.challengeDetailTableView.reloadData()
            })
            .disposed(by: bag)
    }
    
    private func responseAcceptChallengeSuccess() {
        viewModel.output.isAcceptChallengeSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isAcceptChallengeSuccess in
                guard let self = self else { return }
                
                if(isAcceptChallengeSuccess) {
                    self.getInvitedChallengeDetailInfo()
                }
            })
            .disposed(by: bag)
    }
    
    private func responseRejectChallengeSuccess() {
        viewModel.output.isRejectChallengeSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isRejectChallengeSuccess in
                guard let self = self else { return }
                
                if(isRejectChallengeSuccess) {
                    self.popVC()
                }
            })
            .disposed(by: bag)
    }
    
}
