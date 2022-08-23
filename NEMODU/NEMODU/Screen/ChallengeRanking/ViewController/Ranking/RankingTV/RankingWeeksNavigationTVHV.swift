//
//  RankingWeeksNavigationTVHV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/20.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class RankingWeeksNavigationTVHV : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    let containerView = UIView()
    
    let weeksNavigationLabel = UILabel()
        .then {
            $0.text = "20--.-- -주차"
            $0.font = .boldSystemFont(ofSize: 18)
            $0.textColor = .gray900
        }
    lazy var leftNavigationButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray900
            
            $0.addTarget(self, action: #selector(didTapLeftNavigationButton), for: .touchUpInside)
        }
    lazy var rightNavigationButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray900
            
            $0.addTarget(self, action: #selector(didTapRightNavigationButton), for: .touchUpInside)
        }
    
    // MARK: - Variables and Properties
    
    let containerViewHeight: CGFloat = 56
    
    var rankingContainerCVC: RankingContainerCVC?
    
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
    }
    
    func layoutView() {
        contentView.addSubview(containerView)
        containerView.addSubviews([leftNavigationButton, weeksNavigationLabel, rightNavigationButton])
        
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(60)
            
            $0.edges.equalTo(contentView)
        }
        
        leftNavigationButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(leftNavigationButton.snp.width)
            
            $0.centerY.equalTo(weeksNavigationLabel)
            $0.right.equalTo(weeksNavigationLabel.snp.left).inset(-24)
        }
        weeksNavigationLabel.snp.makeConstraints {
            $0.center.equalTo(containerView)
        }
        rightNavigationButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(leftNavigationButton.snp.width)
            
            $0.centerY.equalTo(weeksNavigationLabel)
            $0.left.equalTo(weeksNavigationLabel.snp.right).offset(24)
        }
    }
    
    @objc
    func didTapLeftNavigationButton() {
        rankingContainerCVC?.rankingTableView.reloadSections(IndexSet(1...1), with: .right)
    }
    @objc
    func didTapRightNavigationButton() {
        rankingContainerCVC?.rankingTableView.reloadSections(IndexSet(1...1), with: .left)
    }
    
}
