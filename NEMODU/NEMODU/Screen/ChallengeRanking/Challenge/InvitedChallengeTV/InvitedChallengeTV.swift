//
//  InvitedChallengeTV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/09.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class InvitedChallengeTV : UITableView {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        // Connecting & Register
        delegate = self
        dataSource = self
        
        register(InvitedChallengeTVHV.self, forHeaderFooterViewReuseIdentifier: InvitedChallengeTVHV.className)
        register(InvitedChallengeTVC.self, forCellReuseIdentifier: InvitedChallengeTVC.className)
        register(NoInvitedChallengeTVFV.self, forHeaderFooterViewReuseIdentifier: NoInvitedChallengeTVFV.className)
        
        // Set TableView Style
        separatorStyle = .none
        backgroundColor = .white
        
        // footerView 하단 여백이 생기는 것을 방지(tableView 내의 scrollView의 inset 값 때문인 것으로 추정)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
}

    // MARK: - TableView Delegate / DataSource

extension InvitedChallengeTV : UITableViewDelegate, UITableViewDataSource {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: InvitedChallengeTVHV.className) as? InvitedChallengeTVHV
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvitedChallengeTVC.className, for: indexPath) as! InvitedChallengeTVC
        
        if indexPath.row / 2 == 0 {
            cell.notYetCheckDetailCircleView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("invited TV row selected ", indexPath.row)
    }
    
    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoInvitedChallengeTVFV.className) as? NoInvitedChallengeTVFV
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 93
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 93
    }
    
}
