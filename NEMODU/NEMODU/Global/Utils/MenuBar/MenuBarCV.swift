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

let menuBarCVCIdentifier = "MenuBarCVC"

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
    
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        bindCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 레이아웃이 형성된 뒤에 불려지는 함수
    override func layoutSubviews() {
         super.layoutSubviews()
        
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
            
            $0.left.equalTo(self.snp.left)
            $0.bottom.equalTo(self.snp.bottom)
        }
        
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        // menuBarCollectionView
        menuBarCollectionView.register(MenuBarCVC.self, forCellWithReuseIdentifier: menuBarCVCIdentifier)
        
        menuBarCollectionView.delegate = self
        menuBarCollectionView.dataSource = self
    }
    
    override func layoutView() {
        super.layoutView()
        
        // menuBarCollectionView
        addSubview(menuBarCollectionView)
        menuBarCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.left.equalTo(self.snp.left)
            $0.right.equalTo(self.snp.right)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }
    
    func bindCollectionView() {
        menuBarCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
//        menuBarCollectionView.rx.setDataSource(self).disposed(by: disposeBag)
        
//        let menuBarCVOb: Observable<[String]> = Observable.of(menuList)
        
        let menuBarCVOb = Observable<[String]>.just(menuList)

        menuBarCVOb.bind(to: menuBarCollectionView.rx.items(cellIdentifier: menuBarCVCIdentifier, cellType: MenuBarCVC.self)) { (index: Int, element: String, cell: MenuBarCVC) in
            cell.menuTitle.text = self.menuList[index]
            
            print("bind cellForItemAt called ", index, " ", self.menuList[index])
        }.disposed(by: disposeBag)
         
        
//        menuBarCVOb.bind(to: menuBarCollectionView.rx.items(cellIdentifier: menuBarCVCellIdentifier, cellType: MenuBarCVCell.self)) { (index: Int, menuName: String, cell: MenuBarCVCell) -> Void in
//
//            let indexPath = IndexPath(item: index, section: 0)
//            cell.menuTitle.text = self.menuList[indexPath.item]
//        }
//        .disposed(by: disposeBag)
        
        menuBarCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("hi there", indexPath.item)
                       })
            .disposed(by: disposeBag)
        
        
        
        print("bind collecitionView called")
        
//        menuBarCVOb.bind(to: menuBarCollectionView.rx.items(cellIdentifier: menuBarCVCellIdentifier)) { (collecitionView: UICollectionView, index: Int, menuName: String) -> UICollectionViewCell in
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: menuBarCVCellIdentifier) else { return MenuBarCVCell() }
//            cell.menuTitle.text = menuList[indexPath.item]
//
//            return cell
//        }.dispose(by: bag)
    }
    
}

// MARK: - Menu Bar CollectionView

extension MenuBarCV : UICollectionViewDelegate { }
extension MenuBarCV : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuCount = CGFloat(menuList.count)
        
        return CGSize(width: self.frame.width/menuCount, height: collectionView.frame.height)
    }
    
}

 // MARK: - CollectionView DataSoure

extension MenuBarCV : UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return menuList.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuBarCVC", for: indexPath) as! MenuBarCVC

        cell.menuTitle.text = menuList[indexPath.item]

        return cell
    }
    
}
