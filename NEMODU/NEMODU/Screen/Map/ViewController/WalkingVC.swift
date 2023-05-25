//
//  WalkingVC.swift
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

class WalkingVC: BaseViewController {
    private let mapVC = MapVC()
    
    private let recordBaseView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMaxXMinYCorner,
                                      .layerMinXMinYCorner]
        }
    
    private let pauseBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "pause"), for: .normal)
        }
    
    private let stopBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "stop"), for: .normal)
        }
    
    private let playBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "play"), for: .normal)
        }
    
    private let stopPlayView = UIView()
        .then {
            $0.isHidden = true
        }
    
    private let recordStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    
    private let blocksNumView = RecordView()
        .then {
            $0.recordValue.text = "0"
            $0.recordTitle.text = "채운 칸의 수"
            $0.recordSubtitle.text = "이번주 영역: -칸"
        }
    
    private let distanceView = RecordView()
        .then {
            $0.recordValue.text = "0m"
            $0.recordTitle.text = "거리"
            $0.recordSubtitle.text = " "
        }
    
    private let timeView = RecordView()
        .then {
            $0.recordValue.text = "0:00"
            $0.recordTitle.text = "시간"
            $0.recordSubtitle.text = " "
        }
    
    private var weekBlockCnt = 0
    private var secondTimeValue: Int = 0
    private var startTime: Date?
    private let viewModel = WalkingVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapVC.endRecordDelegate = self
        mapVC.startActivityUpdates()
        setStartTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getHomeData(mapVC.locationManager.location?.coordinate.latitude ?? 0,
                              mapVC.locationManager.location?.coordinate.longitude ?? 0)
    }
    
    override func configureView() {
        super.configureView()
        configureWalkingView()
        mapVC.setUserLocationAnimation(visible: true)
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
        recordViewLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindMapGesture()
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindAPIErrorAlert(viewModel)
        bindRecordValue()
        bindWeekBlocksCnt()
        bindFriendAnnotation()
        bindChallengeFriendAnnotation()
        bindMatrices()
    }
    
    override func bindLoading() {
        super.bindLoading()
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.loading(loading: isLoading)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure

extension WalkingVC {
    private func configureWalkingView() {
        mapVC.isRecording.accept(true)
        addChild(mapVC)
        view.addSubviews([mapVC.view,
                          recordBaseView])
        recordBaseView.addSubviews([stopPlayView, pauseBtn, recordStackView])
        [blocksNumView, distanceView, timeView].forEach {
            recordStackView.addArrangedSubview($0)
        }
        stopPlayView.addSubviews([stopBtn, playBtn])
    }
    
    private func configureWeekBlockCnt(_ cnt: Int) {
        weekBlockCnt = cnt
        blocksNumView.recordSubtitle.text = "이번주 영역: \(cnt.insertComma)칸"
    }
    
    private func setStartTime() {
        startTime = Date.now
    }
}

// MARK: - Layout

extension WalkingVC {
    private func configureLayout() {
        mapVC.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(recordBaseView.snp.top).offset(22 )
        }
        
        recordBaseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(240)
        }
        
        mapVC.currentLocationBtn.snp.makeConstraints {
            $0.bottom.equalTo(recordBaseView.snp.top).offset(-16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(48)
        }
    }
    
    private func recordViewLayout() {
        pauseBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(72)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
        
        recordStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(83)
        }
        
        stopPlayView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(72)
            $0.width.equalTo(168)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
        
        stopBtn.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        playBtn.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension WalkingVC {
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
            .disposed(by: disposeBag)
    }
    
    private func bindBtn() {
        // 일시 정지 버튼
        pauseBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setRecordBtnStatus(isWalking: false)
                self.mapVC.stopUpdateStep()
            })
            .disposed(by: disposeBag)
        
        // 기록 중단 버튼
        stopBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushRecordResultVC()
            })
            .disposed(by: disposeBag)
        
        // 기록 재시작 버튼
        playBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setRecordBtnStatus(isWalking: true)
                self.mapVC.startUpdateStep()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension WalkingVC {
    private func bindRecordValue() {
        // 이동 거리 기록
        mapVC.updateDistance
            .asDriver()
            .drive(onNext: { [weak self] distance in
                guard let self = self else { return }
                self.distanceView.recordValue.text = "\(distance.toKilometer)"
            })
            .disposed(by: disposeBag)
        
        // 이동 시간 기록
        viewModel.timer.driver.asObservable()
            .subscribe(onNext: { [weak self] second in
                guard let self = self,
                      self.mapVC.isRecording.value
                else { return }
                self.secondTimeValue += second
                self.timeView.recordValue.text
                = self.secondTimeValue.toExerciseTime
            })
            .disposed(by: disposeBag)
        
        // 채운 칸 수 기록
        mapVC.blocksCnt
            .asDriver()
            .drive(onNext: { [weak self] blocksCnt in
                guard let self = self else { return }
                self.blocksNumView.recordValue.text = "\(blocksCnt.insertComma)"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindWeekBlocksCnt() {
        viewModel.output.matricesNumber
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] matricesNumber in
                guard let self = self,
                      let cnt = matricesNumber else { return }
                self.configureWeekBlockCnt(cnt)
            })
            .disposed(by: disposeBag)
    }
    
    /// 일반 친구의 마커를 연결하는 메서드
    private func bindFriendAnnotation() {
        viewModel.output.friendsLastLocations
            .subscribe(onNext: { [weak self] friend in
                guard let self = self,
                      let latitude = friend.latitude,
                      let longitude = friend.longitude
                else { return }
                // 마커 추가
                self.mapVC.addFriendAnnotation(coordinate: Matrix(latitude: latitude,
                                                                  longitude: longitude),
                                               profileImageURL: friend.picturePathURL,
                                               nickname: friend.nickname,
                                               color: .main,
                                               isHidden: !self.viewModel.output.friendVisible.value,
                                               isEnabled: true)
            })
            .disposed(by: disposeBag)
    }
    
    /// 챌린지를 함께하는 친구의 마커를 연결하는 메서드
    private func bindChallengeFriendAnnotation() {
        viewModel.output.challengeFriendsLastLocations
            .subscribe(onNext: { [weak self] friend in
                guard let self = self,
                      let latitude = friend.latitude,
                      let longitude = friend.longitude
                else { return }
                // 마커 추가
                self.mapVC.addFriendAnnotation(coordinate: Matrix(latitude: latitude,
                                                                  longitude: longitude),
                                               profileImageURL: friend.picturePathURL,
                                               nickname: friend.nickname,
                                               color: ChallengeColorType(rawValue: friend.challengeColor)?.primaryColor ?? .main,
                                               challengeCnt: friend.challengeNumber,
                                               isHidden: !self.viewModel.output.friendVisible.value,
                                               isEnabled: true)
            })
            .disposed(by: disposeBag)
    }
    
    /// Matrix 배열을 입력받아 지도에 영역을 그리는 메서드
    private func bindMatrices() {
        viewModel.output.matrices
            .subscribe(onNext: { [weak self] nickname, matrices in
                guard let self = self,
                      let blockColor = self.viewModel.input.userTable[nickname] else { return }
                let owner: BlocksType = (nickname == UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)) ? .mine : .friends
                if owner == .mine && self.viewModel.output.myBlocksVisible.value {
                    self.mapVC.drawBlockArea(matrices: matrices,
                                             owner: owner,
                                             blockColor: blockColor.blockColor)
                } else if owner == .friends && self.viewModel.output.friendVisible.value {
                    self.mapVC.drawBlockArea(matrices: matrices,
                                             owner: owner,
                                             blockColor: blockColor.blockColor)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Methods

extension WalkingVC {
    /// 기록 중 상태에 따라 일시정지, 멈춤, 재시작 버튼의 상태를 지정하는 함수
    private func setRecordBtnStatus(isWalking: Bool) {
        stopPlayView.isHidden = isWalking
        pauseBtn.isHidden = !isWalking
        mapVC.isRecording.accept(isWalking)
    }
}

// MARK: - EndRecordingDelegate

extension WalkingVC: EndRecordingDelegate {
    /// 기록 중단 처리 메서드
    func pushRecordResultVC() {
        guard let startTime = self.startTime else { return }
        if self.mapVC.blocks.count < 5 {
            self.popUpAlert(alertType: .minimumBlocks,
                            targetVC: self,
                            highlightBtnAction: #selector(self.dismissAlert),
                            normalBtnAction: #selector(self.dismissToRootVC))
        } else {
            self.mapVC.endActivityUpdates()
            
            let recordResultNC = RecordResultNC()
            recordResultNC.modalPresentationStyle = .fullScreen
            recordResultNC.recordResultVC.configureRecordValue(
                recordData: RecordDataRequest(distance: self.mapVC.updateDistance.value,
                                              exerciseTime: self.secondTimeValue,
                                              matrices: self.mapVC.blocks,
                                              stepCount: self.mapVC.stepCnt,
                                              started: startTime.toString(separator: .withTime),
                                              ended: Date.now.toString(separator: .withTime)),
                weekBlockCnt: self.weekBlockCnt)
            self.present(recordResultNC, animated: true)
        }
    }
}
