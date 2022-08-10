//
//  MainVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/08.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class MainVC: BaseViewController {
    private let mapVC = MapVC()
        .then {
            $0.isWalking = false
        }
    
    private var filterBtn = UIButton()
        .then {
            $0.backgroundColor = UIColor.blue
            $0.setTitle("F", for: .normal)
        }
    
    private var challengeListBtn = UIButton()
        .then {
            $0.backgroundColor = UIColor.blue
            $0.setTitle("C", for: .normal)
        }
    
    private var startWalkBtn = UIButton()
        .then {
            $0.backgroundColor = .secondary
            $0.titleLabel?.font = .headline1
            $0.tintColor = .main
            $0.setTitleColor(.main, for: .normal)
            $0.setTitle("기록 시작하기  ", for: .normal)
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.layer.cornerRadius = 24
            $0.semanticContentAttribute = .forceRightToLeft
        }
    
    private let blocksCnt = UILabel()
        .then {
            $0.font = .headline2
            $0.textColor = .gray800
        }
    
    private let naviBar = NavigationBar()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureMainView()
        configureNaviBar()
        // TODO: - 서버 연결 후 이동
        configureBlocksCnt(72)
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension MainVC {
    private func configureMainView() {
        addChild(mapVC)
        view.addSubviews([mapVC.view, filterBtn, challengeListBtn, startWalkBtn])
    }
    
    private func configureNaviBar() {
        view.addSubview(naviBar)
        let month = Calendar.current.component(.month, from: Date.now)
        let week = Calendar.current.component(.weekOfMonth, from: Date.now)
        naviBar.configureNaviBar(targetVC: self, title: "\(month)월 \(week)주차")
        naviBar.setTitleFont(font: .title2)
    }
    
    private func configureBlocksCnt(_ cnt: Int) {
        view.addSubview(blocksCnt)
        blocksCnt.text = "현재 나의 영역: \(cnt)칸"
    }
}

// MARK: - Layout

extension MainVC {
    private func configureLayout() {
        mapVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        filterBtn.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(48)
        }
        
        mapVC.currentLocationBtn.snp.makeConstraints {
            $0.top.equalTo(filterBtn.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(48)
        }
        
        challengeListBtn.snp.makeConstraints {
            $0.top.equalTo(mapVC.currentLocationBtn.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(48)
        }
        
        startWalkBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.height.equalTo(48)
        }
        
        blocksCnt.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Input

extension MainVC {
    private func bindBtn() {
        // 필터 버튼
        filterBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let filterBottomSheet = MapFilterBottomSheet()
                self.present(filterBottomSheet, animated: true)
            })
            .disposed(by: bag)
        
        // 기록 시작 버튼
        startWalkBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let walkingVC = WalkingVC()
                walkingVC.modalPresentationStyle = .fullScreen
                self.present(walkingVC, animated: false)
            })
            .disposed(by: bag)
        
        // 챌린지 목록 버튼
        challengeListBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let challengeBottomSheet = ChallengeListBottomSheet()
                self.present(challengeBottomSheet, animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MainVC {
    
}
