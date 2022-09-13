//
//  ChallengeContainerCVCell.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeContainerCVC : BaseCollectionViewCell {
    
    // MARK: - UI components
    
    let challengeTableView = UITableView(frame: .zero, style: .grouped)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
        }
    
    lazy var createChallengeButton = UIButton().then {
        $0.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
        $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        $0.tintColor = .main
        $0.backgroundColor = .secondary
        
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        
        $0.addTarget(self, action: #selector(didTapCreateChallengeButton), for: .touchUpInside)
    }
    
    // MARK: - Variables and Properties
    
    var reloadCellIndex = 0
    
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
    
    override func layoutView() {
        super.layoutView()
        
        contentView.addSubviews([challengeTableView, createChallengeButton])
        
        
        challengeTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        createChallengeButton.snp.makeConstraints {
            $0.width.height.equalTo(createChallengeButton.layer.cornerRadius * 2)
            
            $0.right.bottom.equalTo(contentView).inset(16)
        }
    }
    
    @objc
    func didTapCreateChallengeButton() {
        let selectChallengeCreateVC = SelectChallengeCreateVC()
        // TODO: 서버연결 - 임시 주석코드 지정
//        let selectChallengeCreateVC = CreateWeekChallengeVC()
        
        selectChallengeCreateVC.hidesBottomBarWhenPushed = true
        
        let rootViewController = self.findViewController()
        rootViewController?.navigationController?.pushViewController(selectChallengeCreateVC, animated: true)
    }
    
}

// MARK: - ChallengeTableView Delegate

extension ChallengeContainerCVC : UITableViewDelegate { }

// MARK: - ChallengeTableView DataSource

extension ChallengeContainerCVC : UITableViewDataSource {

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
            
            headerView?.challengeListTypeMenuBar.challengeContainerCVC = self
            
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

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        section == 2 ? .leastNormalMagnitude : UITableView.automaticDimension
    }

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 0
        case 2:
            return 5
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: String
        
        switch indexPath.section {
        case 0:
            cellId = InvitedChallengeTVC.className
            
        case 2:
            switch reloadCellIndex {
            case 0:
                cellId = ChallengeWaitingTVC.className
            case 1:
                cellId = ChallengeDoingTVC.className
            case 2:
                cellId = ChallengeFinishTVC.className
            default:
                cellId = ChallengeListTVC.className
            }
            
        default:
            cellId = BaseTableViewCell.className
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("challengeTV row selected ", indexPath.row)
    }

    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var message = ""
        
        switch section {
        case 0:
            message = "초대받은 챌린지가 없습니다."
        case 1:
            let fakeView = UIView()
            fakeView.backgroundColor = .yellow

            return fakeView
        case 2:
            message = NoChallengeStatusMessageType(rawValue: reloadCellIndex)?.message ?? "챌린지 정보를 불러올 수 없습니다."
        default:
            message = NoChallengeStatusMessageType(rawValue: 3)?.message ?? "챌린지 정보를 불러올 수 없습니다."
        }
        
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV
        footerView?.statusLabel.text = message
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == 1 ? .leastNormalMagnitude : 93
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        section == 1 ? .leastNormalMagnitude : 93
    }

}
