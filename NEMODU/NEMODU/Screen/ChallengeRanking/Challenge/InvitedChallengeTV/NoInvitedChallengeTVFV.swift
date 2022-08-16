//
//  NoInvitedChallengeTVFV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/09.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class NoInvitedChallengeTVFV : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    let invitedChallengeLabel = UILabel()
        .then {
            $0.text = "초대받은 챌린지가 없습니다."
            $0.font = .caption2R
            $0.textColor = .gray500
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureFV()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func configureFV() {
        contentView.backgroundColor = .white
    }
    
    func layoutView() {
        contentView.addSubview(invitedChallengeLabel)
        
        invitedChallengeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
