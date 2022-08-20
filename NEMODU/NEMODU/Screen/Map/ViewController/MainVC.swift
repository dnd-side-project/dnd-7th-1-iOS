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
        viewModel.getAllBlocks()
    }
    
    override func configureView() {
        super.configureView()
        configureMainView()
        configureNaviBar()
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
        bindFriendBlocks()
        bindChallengeFriendBlocks()
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
    
    private func drawBlockArea(blocks: [Matrix], blockColor: UIColor) {
        blocks.forEach {
            mapVC.drawBlock(latitude: $0.latitude,
                            longitude: $0.longitude,
                            color: blockColor)
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
    
    // TODO: - 서버 프로필 이미지 추가 후 수정
    private func bindMyBlocks() {
        viewModel.output.myBlocks
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                self.configureBlocksCnt(user.matricesNumber ?? 0)
                
                guard let latitude = user.latitude,
                      let longitude = user.longitude else { return }
                self.mapVC.addMyAnnotation(coordinate: [latitude, longitude],
                                           profileImage: UIImage(named: "defaultThumbnail")!)
                self.drawBlockArea(blocks: user.matrices ?? [],
                                   blockColor: .main30)
            })
            .disposed(by: bag)
    }
    
    private func bindFriendBlocks() {
        viewModel.output.friendBlocks
            .subscribe(onNext: { [weak self] friends in
                guard let self = self else { return }
                friends.forEach {
                    guard let latitude = $0.latitude,
                          let longitude = $0.longitude else { return }
                    self.mapVC.addFriendAnnotation(coordinate: [latitude, longitude],
                                                   profileImage: UIImage(named: "defaultThumbnail")!,
                                                   nickname: $0.nickname,
                                                   color: .main,
                                                   challengeCnt: 0)
                    self.drawBlockArea(blocks: $0.matrices ?? [],
                                       blockColor: .gray25)
                }
            })
            .disposed(by: bag)
    }
    
    private func bindChallengeFriendBlocks() {
        viewModel.output.challengeFriendBlocks
            .subscribe(onNext: { [weak self] friends in
                guard let self = self else { return }
                friends.forEach {
                    self.mapVC.addFriendAnnotation(coordinate: [$0.latitude, $0.longitude],
                                                   profileImage: UIImage(named: "defaultThumbnail")!,
                                                   nickname: $0.nickname,
                                                   color: ChallengeColorType(rawValue: $0.challengeColor)?.primaryColor ?? .main,
                                                   challengeCnt: $0.challengeNumber)
                    self.drawBlockArea(blocks: $0.matrices,
                                       blockColor: ChallengeColorType(rawValue: $0.challengeColor)?.blockColor ?? .gray25)
                }
            })
            .disposed(by: bag)
    }
}
