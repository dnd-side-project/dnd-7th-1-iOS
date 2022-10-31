//
//  RankingVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/05.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class RankingVC : BaseViewController {
    
    // MARK: - UI components
    
    private let rankingListTypeMenuBar = ListTypeMenuBarCV()
        .then {
            $0.menuList = ["영역 랭킹", "걸음수 랭킹", "역대 누적 랭킹"]
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
    
    private let areaRankingListVC = AreaRankingListVC()
    private let stepRankingListVC = StepRankingListVC()
    private let accumulateRankingListVC = AccumulateRankingListVC()
    
    // MARK: - Variables and Properties
    
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindMenuBar()
    }

    // MARK: - Functions
    
}

// MARK: - Layout

extension RankingVC {
    
    private func configureLayout() {
        view.addSubviews([rankingListTypeMenuBar,
                                 baseScrollView])
        baseScrollView.addSubview(baseStackView)
        [areaRankingListVC.view, stepRankingListVC.view, accumulateRankingListVC.view].forEach {
            baseStackView.addArrangedSubview($0)
        }
        [areaRankingListVC, stepRankingListVC, accumulateRankingListVC].forEach {
            addChild($0)
        }
        
        
        rankingListTypeMenuBar.snp.makeConstraints {
            $0.height.equalTo(64)
            
            $0.top.horizontalEdges.equalTo(view)
        }
        
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(rankingListTypeMenuBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
        baseStackView.snp.makeConstraints {
            $0.width.equalTo(view.frame.width * CGFloat(rankingListTypeMenuBar.menuList.count))
            $0.height.equalTo(baseScrollView)
            
            $0.edges.equalTo(baseScrollView)
        }
        
        [areaRankingListVC.view, stepRankingListVC.view, accumulateRankingListVC.view].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(view.frame.width)
                $0.height.equalTo(baseStackView)
            }
        }
    }
    
}

// MARK: - Input

extension RankingVC {

    private func bindMenuBar() {
        rankingListTypeMenuBar.menuBarCollectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let offset = CGFloat(indexPath.row) * self.view.frame.width
                self.baseScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            })
            .disposed(by: bag)
    }
    
}
