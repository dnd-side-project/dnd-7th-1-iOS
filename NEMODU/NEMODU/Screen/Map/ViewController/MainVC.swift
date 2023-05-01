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
        viewModel.getHomeData(mapVC.mapView.region.center.latitude,
                              mapVC.mapView.region.center.longitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapVC.deselectAnnotation()
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
        bindMapGesture()
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindHomeData()
        bindMyAnnotation()
        bindFriendAnnotation()
        bindChallengeFriendAnnotation()
        bindMatrices()
        bindVisible()
    }
    
    override func bindLoading() {
        super.bindLoading()
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.loading(loading: isLoading)
            })
            .disposed(by: bag)
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
    /// 지도 제스쳐에 맞춰 현재 보이는 화면의 영역을 받아오는 메서드
    private func bindMapGesture() {
        mapVC.mapView.rx.anyGesture(.pan(), .pinch())
            .when(.ended)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.getUpdateBlocks(self.mapVC.mapView.region.center.latitude,
                                               self.mapVC.mapView.region.center.longitude,
                                               self.mapVC.mapView.region.span.latitudeDelta)
            })
            .disposed(by: bag)
    }
    
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
                self.mapVC.mapView.removeAnnotations(self.mapVC.mapView.annotations)
                self.viewModel.getHomeData(self.mapVC.mapView.region.center.latitude,
                                           self.mapVC.mapView.region.center.longitude,
                                           self.mapVC.mapView.region.span.latitudeDelta)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension MainVC {
    /// 홈화면 기본 데이터를 연결하는 메서드. (이번 주 나의 영역, 챌린지 개수)
    private func bindHomeData() {
        // 이번 주 나의 영역
        viewModel.output.matricesNumber
            .subscribe(onNext: { [weak self] matricesNumber in
                guard let self = self,
                      let cnt = matricesNumber else { return }
                self.refreshBtnView.configureBlocksCnt(cnt)
            })
            .disposed(by: bag)
        
        // 챌린지 개수
        viewModel.output.challengeCnt
            .subscribe(onNext: { [weak self] cnt in
                guard let self = self else { return }
                self.configureChallengeListBtn(cnt: cnt)
            })
            .disposed(by: bag)
    }
    
    /// 나의 마커를 연결하는 메서드
    private func bindMyAnnotation() {
        viewModel.output.myLastLocation
            .subscribe(onNext: { [weak self] user in
                guard let self = self,
                      let latitude = user.latitude,
                      let longitude = user.longitude,
                      let profileImageURL = user.profileImageURL else { return }
                // 마커 추가
                self.mapVC.addMyAnnotation(coordinate: [latitude, longitude],
                                           profileImageURL: profileImageURL)
                
                // 색상 테이블 추가
                self.viewModel.input.userTable[user.nickname] = ChallengeColorType.green
            })
            .disposed(by: bag)
    }
    
    /// 일반 친구의 마커를 연결하는 메서드
    private func bindFriendAnnotation() {
        viewModel.output.friendsLastLocations
            .subscribe(onNext: { [weak self] friend in
                guard let self = self,
                      let latitude = friend.latitude,
                      let longitude = friend.longitude,
                      let profileImageURL = friend.profileImageURL else { return }
                // 마커 추가
                self.mapVC.addFriendAnnotation(coordinate: [latitude, longitude],
                                               profileImageURL: profileImageURL,
                                               nickname: friend.nickname,
                                               color: .main,
                                               isEnabled: true)
                
                // 색상 테이블 추가
                self.viewModel.input.userTable[friend.nickname] = ChallengeColorType.gray
            })
            .disposed(by: bag)
    }
    
    /// 챌린지를 함께하는 친구의 마커를 연결하는 메서드
    private func bindChallengeFriendAnnotation() {
        viewModel.output.challengeFriendsLastLocations
            .subscribe(onNext: { [weak self] friend in
                guard let self = self,
                      let latitude = friend.latitude,
                      let longitude = friend.longitude,
                      let profileImageURL = friend.profileImageURL else { return }
                // 마커 추가
                self.mapVC.addFriendAnnotation(coordinate: [latitude, longitude],
                                               profileImageURL: profileImageURL,
                                               nickname: friend.nickname,
                                               color: ChallengeColorType(rawValue: friend.challengeColor)?.primaryColor ?? .main,
                                               challengeCnt: friend.challengeNumber,
                                               isEnabled: true)
                
                // 색상 테이블 추가
                self.viewModel.input.userTable[friend.nickname] = ChallengeColorType(rawValue: friend.challengeColor)
            })
            .disposed(by: bag)
    }
    
    /// Matrix 배열을 입력받아 지도에 영역을 그리는 메서드
    private func bindMatrices() {
        viewModel.output.matrices
            .subscribe(onNext: { [weak self] nickname, matrices in
                guard let self = self,
                      let blockColor = self.viewModel.input.userTable[nickname] else { return }
                let owner: BlocksType = (nickname == UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)) ? .mine : .friends
                self.mapVC.drawBlockArea(matrices: matrices,
                                         owner: owner,
                                         blockColor: blockColor.blockColor)
            })
            .disposed(by: bag)
    }
    
    /// 필터 변경에 따라 visible 상태를 변경하는 메서드
    private func bindVisible() {
        viewModel.output.myBlocksVisible
            .asDriver()
            .drive(onNext: { [weak self] status in
                guard let self = self else { return }
                self.setMyArea(visible: status)
            })
            .disposed(by: bag)
        
        viewModel.output.friendVisible
            .asDriver()
            .drive(onNext: { [weak self] status in
                guard let self = self else { return }
                self.setFriendsArea(visible: status)
            })
            .disposed(by: bag)
        
        // TODO: - myLocationVisible MVP2 부터 개발!!
    }
}
