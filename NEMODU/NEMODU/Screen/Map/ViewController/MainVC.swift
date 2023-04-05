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
    
    private let refreshBtnView = RefreshBtnView()
    
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
    
    private var infoMessage = UILabel()
        .then {
            $0.text = "일주일마다 칸이 리셋됩니다."
            $0.font = .headline2
            $0.textColor = .gray800
            $0.textAlignment = .center
        }
    
    private var startWalkBtn = UIButton()
        .then {
            $0.backgroundColor = .secondary
            $0.titleLabel?.font = .headline1
            $0.tintColor = .main
            $0.setTitleColor(.main, for: .normal)
            $0.setTitle("기록 시작하기  ", for: .normal)
            $0.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.layer.cornerRadius = 24
            $0.semanticContentAttribute = .forceRightToLeft
        }
    
    private let viewModel = MainVM()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllBlocks(mapVC.mapView.region.center.latitude,
                               mapVC.mapView.region.center.longitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectAnnotation()
    }
    
    override func configureView() {
        super.configureView()
        configureMainView()
        mapVC.setUserLocationAnimation(visible: false)
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
        bindVisible()
        bindMapGesture()
    }
    
}

// MARK: - Configure

extension MainVC {
    private func configureMainView() {
        addChild(mapVC)
        view.addSubviews([mapVC.view,
                          refreshBtnView,
                          filterBtn,
                          challengeListBtn,
                          infoMessage,
                          startWalkBtn])
        challengeListBtn.addSubview(challengeCnt)
    }
    
    private func configureChallengeListBtn(cnt: Int) {
        challengeCnt.isHidden = cnt == 0
        challengeCnt.text = String(cnt)
    }
    
    private func setMyArea(visible: Bool) {
        mapVC.setOverlayVisible(of: .mine, visible: visible)
        mapVC.setMyAnnotation(visible: visible)
    }
    
    private func setFriendsArea(visible: Bool) {
        mapVC.setOverlayVisible(of: .friends, visible: visible)
        mapVC.setFriendsAnnotation(visible: visible)
    }
}

// MARK: - Layout

extension MainVC {
    private func configureLayout() {
        mapVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        refreshBtnView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(66)
            $0.width.equalTo(163)
        }
        
        filterBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
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
        
        infoMessage.snp.makeConstraints {
            $0.bottom.equalTo(startWalkBtn.snp.top).offset(-16)
            $0.centerX.equalToSuperview()
        }
        
        startWalkBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.height.equalTo(48)
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
                filterBottomSheet.configureBtnStatus(mainVM: self.viewModel,
                                                     myBlocks: self.viewModel.output.myBlocksVisible.value,
                                                     friends: self.viewModel.output.friendVisible.value,
                                                     myLocation: self.viewModel.output.myLocationVisible.value)
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
        
        // 새로고침 영역
        refreshBtnView.rx.tapGesture()
            .when(.ended)
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mapVC.mapView.removeOverlays(self.mapVC.mapView.overlays)
                self.mapVC.mapView.removeAnnotations(self.mapVC.mapView.annotations)
                self.viewModel.getAllBlocks(self.mapVC.mapView.region.center.latitude,
                                            self.mapVC.mapView.region.center.longitude,
                                            self.mapVC.mapView.region.span.latitudeDelta)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MainVC {
    /// span 값에 따라 visible 상태가 적용 안되는 경우를 고려하여 scroll시마다 visible 상태 적용
    private func bindMapGesture() {
        mapVC.mapView.rx.anyGesture(.pan(), .pinch())
            .when(.began)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setMyArea(visible: self.viewModel.output.myBlocksVisible.value)
                self.setFriendsArea(visible: self.viewModel.output.friendVisible.value)
            })
            .disposed(by: bag)
    }
    
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
                self.refreshBtnView.configureBlocksCnt(user.matricesNumber ?? 0)
                
                guard let latitude = user.latitude,
                      let longitude = user.longitude,
                      let profileImageURL = user.profileImageURL else { return }
                
                // Annotation
                self.mapVC.addMyAnnotation(coordinate: [latitude, longitude],
                                           profileImageURL: profileImageURL)
                
                // Area
                self.mapVC.drawBlockArea(matrices: user.matrices ?? [],
                                         owner: .mine,
                                         blockColor: .main40)
                
                self.setMyArea(visible: self.viewModel.output.myBlocksVisible.value)
            })
            .disposed(by: bag)
    }
    
    private func bindFriendBlocks() {
        viewModel.output.friendBlocks
            .subscribe(onNext: { [weak self] friends in
                guard let self = self else { return }
                friends.forEach {
                    guard let latitude = $0.latitude,
                          let longitude = $0.longitude,
                          let profileImageURL = $0.profileImageURL else { return }
                    let nickname = $0.nickname
                    
                    // Annotation
                    self.mapVC.addFriendAnnotation(coordinate: [latitude, longitude],
                                                   profileImageURL: profileImageURL,
                                                   nickname: nickname,
                                                   color: .main,
                                                   challengeCnt: 0,
                                                   isEnabled: true)
                    
                    // Area
                    self.mapVC.drawBlockArea(matrices: $0.matrices ?? [],
                                             owner: .friends,
                                             blockColor: .gray25)
                }
                
                self.setFriendsArea(visible: self.viewModel.output.friendVisible.value)
            })
            .disposed(by: bag)
    }
    
    private func bindChallengeFriendBlocks() {
        viewModel.output.challengeFriendBlocks
            .subscribe(onNext: { [weak self] friends in
                guard let self = self else { return }
                friends.forEach {
                    guard let profileImageURL = $0.profileImageURL else { return }
                    
                    // Annotation
                    self.mapVC.addFriendAnnotation(coordinate: [$0.latitude, $0.longitude],
                                                   profileImageURL: profileImageURL,
                                                   nickname: $0.nickname,
                                                   color: ChallengeColorType(rawValue: $0.challengeColor)?.primaryColor ?? .main,
                                                   challengeCnt: $0.challengeNumber,
                                                   isEnabled: true)
                    
                    // Area
                    self.mapVC.drawBlockArea(matrices: $0.matrices,
                                             owner: .friends,
                                             blockColor: ChallengeColorType(rawValue: $0.challengeColor)?.blockColor ?? .gray25)
                }
                
                self.setFriendsArea(visible: self.viewModel.output.friendVisible.value)
            })
            .disposed(by: bag)
    }
    
    private func bindVisible() {
        viewModel.output.myBlocksVisible
            .asDriver()
            .drive(onNext: { [weak self] isVisible in
                guard let self = self else { return }
                self.setMyArea(visible: isVisible)
            })
            .disposed(by: bag)
        
        viewModel.output.friendVisible
            .asDriver()
            .drive(onNext: { [weak self] isVisible in
                guard let self = self else { return }
                self.setFriendsArea(visible: isVisible)
            })
            .disposed(by: bag)
        
        // TODO: - myLocationVisible MVP2 부터 개발!!
    }
    
    private func deselectAnnotation() {
        mapVC.mapView.selectedAnnotations.forEach {
            mapVC.mapView.deselectAnnotation($0, animated: true)
        }
    }
}
