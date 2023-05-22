//
//  ChallengeTitleTVHV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/09.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeTitleTVHV : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    let containerView = UIView()
    
    let challengeTitleLabel = UILabel()
        .then {
            $0.text = "- 챌린지"
            $0.font = .body1
            $0.textColor = .gray800
        }
    
    let challengeTitleBorderLineView = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    // MARK: - Variables and Properties
    
    let containerViewHeight: CGFloat = 56
    
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
        contentView.autoresizingMask = .flexibleHeight
    }
    
    func layoutView() {
        contentView.addSubview(containerView)
        containerView.addSubviews([challengeTitleLabel, challengeTitleBorderLineView])
        
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(containerViewHeight).priority(.high)
            
            $0.top.equalTo(contentView.snp.top)
            $0.horizontalEdges.equalTo(contentView)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        challengeTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(containerView)
            
            $0.horizontalEdges.equalTo(containerView).inset(16)
        }
        challengeTitleBorderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.horizontalEdges.equalTo(containerView)
            $0.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
}
