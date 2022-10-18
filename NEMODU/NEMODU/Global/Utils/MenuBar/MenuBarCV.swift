//
//  MenuBarCV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class MenuBarCV: BaseView {
    
    // MARK: - UI components
    
    lazy var menuBarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        .then {
            $0.backgroundColor = .white
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
        }
    
    let positionBarView = UIView()
        .then {
            $0.backgroundColor = .black
        }
    
    // MARK: - Variables and Properties
    
    var menuList = [""]
    
    // MARK: - Life Cycle
    
    // 레이아웃이 형성된 뒤에 불려지는 함수
    override func layoutSubviews() {
         super.layoutSubviews()
        
        setStartTabPosition()
    }
    
    override func configureView() {
        super.configureView()
        
        configureCollectionView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configreLayout()
    }
    
    // MARK: - Functions
    
    private func setStartTabPosition() {
        _ = menuBarCollectionView.then {
            // 최초 실행 시 선택되어 있는 위치 지정
            let indexPath = IndexPath(item: 0, section: 0)
            $0.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        
        // 레이아웃이 형성된 뒤에 작업해야 정상적으로 설정된다
        addSubview(positionBarView)
        positionBarView.snp.makeConstraints {
            let width = menuBarCollectionView.frame.size.width / CGFloat(menuList.count)
            $0.width.equalTo(width)
            
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureCollectionView() {
        menuBarCollectionView.register(MenuBarCVC.self, forCellWithReuseIdentifier: MenuBarCVC.className)
        
        menuBarCollectionView.delegate = self
        menuBarCollectionView.dataSource = self
    }
    
    func configreLayout() {
        addSubview(menuBarCollectionView)
        
        menuBarCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

// MARK: - Configure

extension MenuBarCV {
    
}

// MARK: - Layout

extension MenuBarCV {
    
}

// MARK: - CollectionView DataSoure

extension MenuBarCV : UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return menuList.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: MenuBarCVC.className, for: indexPath) as? MenuBarCVC
        else { return UICollectionViewCell() }
        
        cell.menuTitle.text = menuList[indexPath.item]

        return cell
    }
    
}

// MARK: - CollectionView Delegate

extension MenuBarCV : UICollectionViewDelegate { }

// MARK: - CollectionView DelegateFlowLayout

extension MenuBarCV : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuCount = CGFloat(menuList.count)
        
        return CGSize(width: self.frame.width/menuCount, height: collectionView.frame.height)
    }
    
}
