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
            $0.text = "초대받은 챌린지"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 19)
            
            $0.backgroundColor = .white
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
        
    }
    
    func layoutView() {
        contentView.addSubview(invitedChallengeLabel)
        invitedChallengeLabel.addSubview(invitedChallengeBorderLineView)
        
        
        invitedChallengeLabel.snp.makeConstraints {
            $0.height.equalTo(52)
            
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
        }
        invitedChallengeBorderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.left.equalTo(invitedChallengeLabel.snp.left)
            $0.right.equalTo(invitedChallengeLabel.snp.right)
            $0.bottom.equalTo(invitedChallengeLabel.snp.bottom)
        }
        
    }
    
}
