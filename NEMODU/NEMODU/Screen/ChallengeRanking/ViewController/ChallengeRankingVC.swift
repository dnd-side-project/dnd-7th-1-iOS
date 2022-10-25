//
//  ChallengeRankingVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeRankingVC: BaseViewController {
    
    // MARK: - UI components
    
    private let challengeRankingMenuBar = ChallengeRankingMenuBarCV()
        .then {
            $0.menuList = ["챌린지", "랭킹"]
        }
    
    private let baseScrollView = UIScrollView()
    .then {
        $0.isPagingEnabled = true
        
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    private let baseStackView = UIStackView()
        .then {
            $0.spacing = 0
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .fill
        }
    
    private let challengeVC = ChallengeVC()
    private let rankingVC = RankingVC()
    
    // MARK: - Variables and Properties
    
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
    }
    
    override func layoutView() {
        super.layoutView()
        
        configreLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindMenuBar()
    }

    // MARK: - Functions
    
}

// MARK: - Layout

extension ChallengeRankingVC {
    
    private func configreLayout() {
        view.addSubviews([challengeRankingMenuBar,
                          baseScrollView])
        baseScrollView.addSubview(baseStackView)
        [challengeVC.view, rankingVC.view].forEach {
            baseStackView.addArrangedSubview($0)
        }
        [challengeVC, rankingVC].forEach {
            addChild($0)
        }
        
        challengeRankingMenuBar.snp.makeConstraints {
            $0.height.equalTo(59)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalTo(view)
        }

        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(challengeRankingMenuBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
        baseStackView.snp.makeConstraints {
            $0.width.equalTo(view.frame.width * CGFloat(challengeRankingMenuBar.menuList.count))
            $0.height.equalTo(baseScrollView)
            
            $0.edges.equalTo(baseScrollView)
        }
        
        [challengeVC.view, rankingVC.view].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(view.frame.width)
                $0.height.equalTo(baseStackView)
            }
        }
    }
    
}

// MARK: - Input

extension ChallengeRankingVC {

    private func bindMenuBar() {
        challengeRankingMenuBar.menuBarCollectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let offset = CGFloat(indexPath.row) * self.view.frame.width
                self.baseScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            })
            .disposed(by: bag)
        
        baseScrollView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] contentOffset in
                guard let self = self else { return }
                
                self.challengeRankingMenuBar.positionBarView.frame.origin.x = contentOffset.x / CGFloat(self.challengeRankingMenuBar.menuList.count)
            })
            .disposed(by: bag)
    }
    
}
