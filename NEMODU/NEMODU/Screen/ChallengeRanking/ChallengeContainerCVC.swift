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
    
    let invitedChallengeTableView = InvitedChallengeTV()
        
    // MARK: - Variables and Properties
    
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
    }
    
    override func layoutView() {
        super.layoutView()
        
        contentView.addSubview(invitedChallengeTableView)
        
        invitedChallengeTableView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}
