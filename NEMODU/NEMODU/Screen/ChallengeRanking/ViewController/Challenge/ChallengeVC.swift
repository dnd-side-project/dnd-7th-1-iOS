//
//  ChallengeVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/18.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeVC : BaseViewController {
    
    // MARK: - UI components
    
    let challengeTableView = UITableView(frame: .zero, style: .grouped)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.rowHeight = 116.0
        }
    
    private lazy var createChallengeButton = UIButton().then {
        $0.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
        $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        $0.tintColor = .main
        $0.backgroundColor = .secondary
        
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Variables and Properties
    
    var reloadCellIndex = 0
    
    var invitedChallengeListResponseModel: InvitedChallengeListResponseModel?
    
    var waitChallengeListResponseModel: WaitChallengeListResponseModel?
    var progressChallengeListResponseModel: ProgressAndDoneChallengeListResponseModel?
    var doneChallengeListResponseModel: ProgressAndDoneChallengeListResponseModel?
    
    private let viewModel = ChallengeVM()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getChallengeList()
    }
    
    override func configureView() {
        super.configureView()
        
        configureTableView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindAPIErrorAlert(viewModel)
        bindInvitedList()
        bindChallengeList()
    }

    // MARK: - Functions
    
    private func getChallengeList() {
        DispatchQueue.global().sync {
            let beforeCntInvited = invitedChallengeListResponseModel?.count
            let beforeCntWait = waitChallengeListResponseModel?.count
            let beforeCntProgress = progressChallengeListResponseModel?.count
            let beforeCntDone = doneChallengeListResponseModel?.count

            // 초대받은 챌린지
            viewModel.getInvitedChallengeList()
            
            // 챌린지 내역
            viewModel.getWaitChallengeList()
            viewModel.getProgressChallengeList()
            viewModel.getDoneChallengeList()

            if invitedChallengeListResponseModel?.count != beforeCntInvited ||
                waitChallengeListResponseModel?.count != beforeCntWait ||
                progressChallengeListResponseModel?.count != beforeCntProgress ||
                doneChallengeListResponseModel?.count != beforeCntDone {
                challengeTableView.reloadData()
            } else {
                reloadChallengeTableView(toMoveIndex: reloadCellIndex)
            }
        }
    }
    
    func reloadChallengeTableView(toMoveIndex: Int) {
        let curIndex = reloadCellIndex
        reloadCellIndex = toMoveIndex
        
        if toMoveIndex == curIndex {
            challengeTableView.reloadData()
        } else {
            challengeTableView.reloadSections(IndexSet(2...2), with: toMoveIndex < curIndex ? .right : .left)
        }
    }
    
}

// MARK: - Configure

extension ChallengeVC {
    
    private func configureTableView() {
        _ = challengeTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                
                // headerView
                $0.register(ChallengeTitleTVHV.self, forHeaderFooterViewReuseIdentifier: ChallengeTitleTVHV.className)
                
                $0.register(InvitedChallengeTVHV.self, forHeaderFooterViewReuseIdentifier: InvitedChallengeTVHV.className)
                $0.register(ChallengeListTVHV.self, forHeaderFooterViewReuseIdentifier: ChallengeListTVHV.className)
                
                // cell
                $0.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.className)
                
                $0.register(InvitedChallengeTVC.self, forCellReuseIdentifier: InvitedChallengeTVC.className)
                
                $0.register(ChallengeListTVC.self, forCellReuseIdentifier: ChallengeListTVC.className)
                $0.register(ChallengeWaitingTVC.self, forCellReuseIdentifier: ChallengeWaitingTVC.className)
                $0.register(ChallengeDoingTVC.self, forCellReuseIdentifier: ChallengeDoingTVC.className)
                $0.register(ChallengeFinishTVC.self, forCellReuseIdentifier: ChallengeFinishTVC.className)
                
                // footerView
                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
                
                // footerView 하단 여백이 생기는 것을 방지(tableView 내의 scrollView의 inset 값 때문인 것으로 추정)
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
            }
    }
    
}

// MARK: - Layout

extension ChallengeVC {
    
    private func configureLayout() {
        view.addSubviews([challengeTableView,
                          createChallengeButton])
        
        
        challengeTableView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        createChallengeButton.snp.makeConstraints {
            $0.width.height.equalTo(createChallengeButton.layer.cornerRadius * 2)

            $0.right.bottom.equalTo(view).inset(16)
        }
    }
    
}

// MARK: - TableView DataSource

extension ChallengeVC : UITableViewDataSource {

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // 초대받은 챌린지
            return invitedChallengeListResponseModel?.count ?? 0
        case 1: // 챌린지 내역 및 메뉴바
            return 0
        case 2: // 챌린지 목록
            switch reloadCellIndex {
            case 0: // 진행 대기중
                return waitChallengeListResponseModel?.count ?? 0
            case 1: // 진행 중
                return progressChallengeListResponseModel?.count ?? 0
            case 2: // 진행 완료
                return doneChallengeListResponseModel?.count ?? 0
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // 초대받은 챌린지
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InvitedChallengeTVC.className, for: indexPath) as? InvitedChallengeTVC else { return UITableViewCell() }
            cell.challengeVC = self
            guard let invitedChallengeList = invitedChallengeListResponseModel else { return UITableViewCell() }
            cell.configureInvitedChallengeTVC(invitedChallengeListElement: invitedChallengeList[indexPath.row])
            return cell
            
        case 2: // 챌린지 목록
            switch reloadCellIndex {
            case 0: // 진행 대기중
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeWaitingTVC.className, for: indexPath) as? ChallengeWaitingTVC else { return UITableViewCell() }
                guard let waitChallengeList = waitChallengeListResponseModel else { return UITableViewCell() }
                cell.configureChallengeWaitTVC(waitChallengeListElement: waitChallengeList[indexPath.row])
                return cell
            case 1: // 진행 중
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeDoingTVC.className, for: indexPath) as? ChallengeDoingTVC else { return UITableViewCell() }
                guard let progressChallengeList = progressChallengeListResponseModel else { return UITableViewCell() }
                cell.configureChallengeDoingTVC(progressChallengeListElement: progressChallengeList[indexPath.row])
                return cell
            case 2: // 진행 완료
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeFinishTVC.className, for: indexPath) as? ChallengeFinishTVC else { return UITableViewCell() }
                guard let doneChallengeList = doneChallengeListResponseModel else { return UITableViewCell() }
                cell.configureChallengeFinishTVC(doneChallengeListElement: doneChallengeList[indexPath.row])
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeListTVC.className, for: indexPath) as? ChallengeListTVC else { return UITableViewCell() }
                return cell
            }
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.className, for: indexPath) as? BaseTableViewCell else { return UITableViewCell() }
            return cell
        }
    }

}

// MARK: - TableView Delegate

extension ChallengeVC : UITableViewDelegate {
    
    // HeaderView
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerId: String
        
        switch section {
        case 0:
            headerId = InvitedChallengeTVHV.className
        case 1:
            headerId = ChallengeListTVHV.className
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? ChallengeListTVHV
            headerView?.challengeListTypeMenuBar.challengeVC = self
            
            return headerView
        case 2:
            let fakeView = UIView()
            fakeView.backgroundColor = .green

            return fakeView
        default:
            headerId = ChallengeTitleTVHV.className
        }

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? ChallengeTitleTVHV
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 2 ? .leastNormalMagnitude : UITableView.automaticDimension
    }

    // Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // 초대받은 챌린지
            break
        case 2: // 챌린지 목록
            switch reloadCellIndex {
            case 0: // 진행 대기중
                guard let waitChallengeList = waitChallengeListResponseModel else { return }
                
                let invitedChallengeDetailVC = InvitedChallengeDetailVC()
                invitedChallengeDetailVC.uuid = waitChallengeList[indexPath.row].uuid
                invitedChallengeDetailVC.getInvitedChallengeDetailInfo()
                
                invitedChallengeDetailVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(invitedChallengeDetailVC, animated: true)
            case 1: // 진행 중
                let challengeHistoryDetailVC = ChallengeHistoryDetailVC()
                challengeHistoryDetailVC.hidesBottomBarWhenPushed = true
                
                guard let progressChallengeList = progressChallengeListResponseModel else { return }
                challengeHistoryDetailVC.getChallengeHistoryDetailInfo(uuid: progressChallengeList[indexPath.row].uuid)
                
                navigationController?.pushViewController(challengeHistoryDetailVC, animated: true)
            case 2: // 진행 완료
                let challengeHistoryDetailVC = ChallengeHistoryDetailVC()
                challengeHistoryDetailVC.hidesBottomBarWhenPushed = true
                challengeHistoryDetailVC.configureChallengeDoneLayout()
                
                guard let doneChallengeList = doneChallengeListResponseModel else { return }
                challengeHistoryDetailVC.getChallengeHistoryDetailInfo(uuid: doneChallengeList[indexPath.row].uuid)
                
                navigationController?.pushViewController(challengeHistoryDetailVC, animated: true)
            default:
                break
            }
            
        default:
            break
        }
    }
    
    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var message = ""
        
        switch section {
        case 0: // 초대받은 챌린지
            message = "초대받은 챌린지가 없습니다."
        case 1: // 챌린지 내역 및 메뉴바
            let fakeView = UIView()
            fakeView.backgroundColor = .yellow

            return fakeView
        case 2: // 챌린지 목록(진행 대기중, 진행 중, 진행 완료)
            message = NoChallengeStatusMessageType(rawValue: reloadCellIndex)?.message ?? "챌린지 정보를 불러올 수 없습니다."
        default:
            message = NoChallengeStatusMessageType(rawValue: 3)?.message ?? "챌린지 정보를 불러올 수 없습니다."
        }
        
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV
        footerView?.statusLabel.text = message
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0: // 초대받은 챌린지
            return invitedChallengeListResponseModel?.count ?? 0 == 0 ? 93 : .leastNormalMagnitude
        case 1: // 챌린지 내역 및 메뉴바
            return .leastNormalMagnitude
        case 2: // 챌린지 목록
            switch reloadCellIndex {
            case 0: // 진행 대기중
                return waitChallengeListResponseModel?.count ?? 0 == 0 ? 93 : .leastNormalMagnitude
            case 1: // 진행 중
                return progressChallengeListResponseModel?.count ?? 0 == 0 ? 93 : .leastNormalMagnitude
            case 2: // 진행 완료
                return doneChallengeListResponseModel?.count ?? 0 == 0 ? 93 : .leastNormalMagnitude
            default:
                return 93
            }
        default:
            return 93
        }
    }

}

// MARK: - Input

extension ChallengeVC {
    private func bindButton() {
        createChallengeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let selectChallengeCreateVC = SelectChallengeCreateVC()
                selectChallengeCreateVC.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(selectChallengeCreateVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension ChallengeVC {
    private func bindInvitedList() {
        viewModel.output.invitedChallengeList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.invitedChallengeListResponseModel = data
                self.challengeTableView.reloadSections(IndexSet(0...0), with: .none)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChallengeList() {
        viewModel.output.waitChallengeList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.waitChallengeListResponseModel = data
            })
            .disposed(by: disposeBag)
        
        viewModel.output.progressChallengeList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.progressChallengeListResponseModel = data
            })
            .disposed(by: disposeBag)
        
        viewModel.output.doneChallengeList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.doneChallengeListResponseModel = data
            })
            .disposed(by: disposeBag)
    }
}
