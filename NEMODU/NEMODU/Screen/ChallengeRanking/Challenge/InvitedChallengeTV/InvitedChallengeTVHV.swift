//
//  InvitedChallengeTVHV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/09.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class InvitedChallengeTVHV : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    let invitedChallengeLabel = UILabel()
        .then {
            $0.text = "초대받은 챌린지"
            $0.font = .body1
            $0.textColor = .gray800
        }
    
    
    let invitedChallengeBorderLineView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureHV()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func configureHV() {
        contentView.backgroundColor = .white
        
        // console 창에 뜨는 headerView width 경고 창을 방지하기 위한 코드. 가장 마지막 contraints가 적용되어서 width의 충돌(breaking)을 없앤다
        contentView.autoresizingMask = .flexibleWidth
    }
    
    func layoutView() {
        contentView.addSubview(invitedChallengeLabel)
        contentView.addSubview(invitedChallengeBorderLineView)
        
        
        invitedChallengeLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            
            $0.horizontalEdges.equalTo(contentView).inset(16)
        }
        invitedChallengeBorderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.horizontalEdges.equalTo(contentView)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}
