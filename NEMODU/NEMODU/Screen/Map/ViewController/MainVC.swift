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
    
    private var challengeListBtn = UIButton()
        .then {
            $0.backgroundColor = UIColor.blue
            $0.setTitle("C", for: .normal)
        }
    
    private var startWalkBtn = UIButton()
        .then {
            $0.backgroundColor = UIColor.gray
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.setTitle("기록 시작하기", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            $0.layer.cornerRadius = 25
        }
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureMainView()
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
        view.addSubviews([mapVC.view, challengeListBtn, startWalkBtn])
    }
}

// MARK: - Layout

extension MainVC {
    private func configureLayout() {
        mapVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        challengeListBtn.snp.makeConstraints {
            $0.top.equalTo(mapVC.currentLocationBtn.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(48)
        }
        
        startWalkBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - Input

extension MainVC {
    private func bindBtn() {
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
