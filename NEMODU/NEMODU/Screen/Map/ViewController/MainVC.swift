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
            $0.setImage(UIImage(named: "filter"), for: .normal)
            $0.addShadow()
        }
    
    private var challengeListBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "challenge"), for: .normal)
            $0.addShadow()
        }
    private let challengeCnt = UILabel()
        .then {
            $0.isHidden = true
            $0.backgroundColor = .main
            $0.textColor = .secondary
            $0.textAlignment = .center
            $0.font = .caption1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
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
            $0.text = "현재 나의 영역: -칸"
            $0.font = .headline2
            $0.textColor = .gray800
        }
    
    private let naviBar = NavigationBar()
    private let viewModel = MainVM()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllBlocks()
    }
    
    override func configureView() {
        super.configureView()
        configureMainView()
        configureNaviBar()
        
        // TODO: - 서버 연결 후 수정
        mapVC.addFriendAnnotation(coordinate: [37.329314, -122.019744],
                                  profileImage: UIImage(named: "defaultThumbnail")!,
                                  nickname: "가나다라마바사",
                                  color: .pink100,
                                  challengeCnt: 3)
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
        bindChallengeCnt()
        bindMyBlocks()
    }
    
}

// MARK: - Configure

extension MainVC {
    private func configureMainView() {
        addChild(mapVC)
        view.addSubviews([mapVC.view, blocksCnt, filterBtn, challengeListBtn, startWalkBtn])
        challengeListBtn.addSubview(challengeCnt)
    }
    
    private func configureNaviBar() {
        view.addSubview(naviBar)
        let month = Calendar.current.component(.month, from: Date.now)
        let week = Calendar.current.component(.weekOfMonth, from: Date.now)
        naviBar.configureNaviBar(targetVC: self, title: "\(month)월 \(week)주차")
        naviBar.setTitleFont(font: .title2)
    }
    
    private func configureBlocksCnt(_ cnt: Int) {
        blocksCnt.text = "현재 나의 영역: \(cnt)칸"
    }
    
    private func configureChallengeListBtn(cnt: Int) {
        challengeCnt.isHidden = cnt == 0
        challengeCnt.text = String(cnt)
    }
    
    private func drawBlockArea(blocks: [Matrix]) {
        blocks.forEach {
            mapVC.drawBlock(latitude: $0.latitude,
                            longitude: $0.longitude)
        }
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
        
        challengeCnt.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(6)
            $0.width.height.equalTo(20)
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
                let countdownVC = CountdownVC()
                countdownVC.modalPresentationStyle = .fullScreen
                self.present(countdownVC, animated: true)
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
    private func bindChallengeCnt() {
        viewModel.output.challengeCnt
            .subscribe(onNext: { [weak self] cnt in
                guard let self = self else { return }
                self.configureChallengeListBtn(cnt: cnt)
            })
            .disposed(by: bag)
    }
    
    private func bindMyBlocks() {
        viewModel.output.myBlocks
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                self.configureBlocksCnt(user.matricesNumber ?? 0)
                self.mapVC.addMyAnnotation(coordinate: [user.latitude + self.mapVC.blockSizePoint / 2,
                                                        user.longitude - self.mapVC.blockSizePoint / 2],
                                           profileImage: UIImage(named: "defaultThumbnail")!)
                self.drawBlockArea(blocks: user.matrices)
            })
            .disposed(by: bag)
    }
}
