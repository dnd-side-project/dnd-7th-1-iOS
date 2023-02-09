//
//  TabView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TabView: BaseView {
    var tabCV = UICollectionView(frame: .zero,
                                 collectionViewLayout: UICollectionViewFlowLayout())
        .then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = .zero
            layout.minimumInteritemSpacing = .zero
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            $0.collectionViewLayout = layout
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
        }
    
    var indicatorBaseView = UIView()
        .then {
            $0.backgroundColor = .gray400
        }
    
    var indicator = UIView()
        .then {
            $0.backgroundColor = .gray900
        }
    
    var menu: [String] = []
    
    private let bag = DisposeBag()
    
    private var tab = 0
    
    override func configureView() {
        super.configureView()
        configureContentView()
        bindIndicatorScroll()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureFirstTab(tab)
    }
}

// MARK: - Configure

extension TabView {
    private func configureContentView() {
        addSubviews([tabCV,
                     indicatorBaseView])
        indicatorBaseView.addSubview(indicator)
        
        tabCV.register(TabCVC.self, forCellWithReuseIdentifier: TabCVC.className)
        tabCV.delegate = self
        tabCV.dataSource = self
        
    }
    
    private func bindIndicatorScroll() {
        tabCV.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tab = indexPath.row
                self.indicatorScrollMotion(indexPath.row)
            })
            .disposed(by: bag)
    }
    
    /// 시작 탭을 지정하는 메서드
    func configureFirstTab(_ tabIdx: Int) {
        tabCV.selectItem(at: [0, tabIdx],
                         animated: false,
                         scrollPosition: .left)

        indicatorLayout(tabIdx)
    }
    
    /// 메뉴탭의 tab과 indicator을 모두 선택하는 메서드
    func selectTab(_ tabIdx: Int) {
        tabCV.selectItem(at: [0, tabIdx],
                         animated: false,
                         scrollPosition: .left)
        
        indicatorScrollMotion(tabIdx)
    }
}

// MARK: - Layout

extension TabView {
    private func configureLayout() {
        tabCV.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        indicatorBaseView.snp.makeConstraints {
            $0.top.equalTo(tabCV.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    private func indicatorLayout(_ tabIdx: Int) {
        let offset = CGFloat(tabIdx) * indicator.frame.width
        
        indicator.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(offset)
            $0.width.equalTo(tabCV.snp.width).dividedBy(menu.count)
        }
    }
    
    private func indicatorScrollMotion(_ tabIdx: Int) {
        if tab == tabIdx { return }
        tab = tabIdx
        
        let offset = CGFloat(tabIdx) * indicator.frame.width
        UIView.animate(withDuration: 0.2) {
            self.indicator.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(offset)
            }
            self.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tabCV.dequeueReusableCell(withReuseIdentifier: TabCVC.className, for: indexPath) as? TabCVC else { return UICollectionViewCell() }
        
        cell.configureTabTitle(with: menu[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / CGFloat(menu.count),
               height: collectionView.frame.height)
    }
}

