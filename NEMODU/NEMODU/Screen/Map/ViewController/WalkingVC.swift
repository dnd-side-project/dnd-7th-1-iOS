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
        .then {
            $0.isWalking = true
        }
    
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
    private let viewModel = WalkingVM()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapVC.updateStep()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getBlocksCnt()
    }
    
    override func configureView() {
        super.configureView()
        configureWalkingView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
        recordViewLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindRecordValue()
        bindWeekBlocksCnt()
        bindMyBlocks()
        bindFriendBlocks()
        bindChallengeFriendBlocks()
    }
}

// MARK: - Configure

extension WalkingVC {
    private func configureWalkingView() {
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
    
    private func drawBlockArea(blocks: [Matrix], owner: BlocksType, blockColor: UIColor) {
        blocks.forEach {
            mapVC.drawBlock(latitude: $0.latitude,
                            longitude: $0.longitude,
                            owner: owner,
                            color: blockColor)
        }
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
    private func bindBtn() {
        // 일시 정지 버튼
        pauseBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setRecordBtnStatus(isWalking: false)
                self.mapVC.stopUpdateStep()
            })
            .disposed(by: bag)
        
        // 기록 중단 버튼
        stopBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let recordResultNC = RecordResultNC()
                recordResultNC.modalPresentationStyle = .fullScreen
                recordResultNC.recordResultVC.configureRecordValue(
                    recordData: RecordDataRequest(distance: self.mapVC.updateDistance.value,
                                                  exerciseTime: self.secondTimeValue,
                                                  blocks: self.mapVC.blocks,
                                                  stepCount: self.mapVC.stepCnt),
                    weekBlockCnt: self.weekBlockCnt)
                self.mapVC.stopUpdateStep()
                self.present(recordResultNC, animated: true)
            })
            .disposed(by: bag)
        
        // 기록 재시작 버튼
        playBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setRecordBtnStatus(isWalking: true)
                self.mapVC.updateStep()
            })
            .disposed(by: bag)
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
            .disposed(by: bag)
        
        // 이동 시간 기록
        viewModel.output.driver.asObservable()
            .subscribe(onNext: { [weak self] second in
                guard let self = self else { return }
                if self.mapVC.isWalking ?? false {
                    self.secondTimeValue += second
                    self.timeView.recordValue.text
                    = "\(self.secondTimeValue / 60):"
                    + String(format: "%02d", self.secondTimeValue % 60)
                }
            })
            .disposed(by: bag)
        
        // 채운 칸 수 기록
        mapVC.blocksCnt
            .asDriver()
            .drive(onNext: { [weak self] blocksCnt in
                guard let self = self else { return }
                self.blocksNumView.recordValue.text = "\(blocksCnt.insertComma)"
            })
            .disposed(by: bag)
    }
    
    private func bindWeekBlocksCnt() {
        viewModel.output.blocksCnt
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] cnt in
                guard let self = self else { return }
                self.configureWeekBlockCnt(cnt)
            })
            .disposed(by: bag)
    }
    
    private func bindMyBlocks() {
        viewModel.output.myBlocks
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                self.configureWeekBlockCnt(user.matricesNumber ?? 0)
                
                if !self.viewModel.output.myBlocksVisible.value { return }
                self.drawBlockArea(blocks: user.matrices ?? [],
                                   owner: .mine,
                                   blockColor: .main40)
            })
            .disposed(by: bag)
    }
    
    private func bindFriendBlocks() {
        viewModel.output.friendBlocks
            .subscribe(onNext: { [weak self] friends in
                guard let self = self else { return }
                if !self.viewModel.output.friendVisible.value { return }
                friends.forEach {
                    guard let latitude = $0.latitude,
                          let longitude = $0.longitude else { return }
                    self.mapVC.addFriendAnnotation(coordinate: [latitude, longitude],
                                                   profileImage: UIImage(named: "defaultThumbnail")!,
                                                   nickname: $0.nickname,
                                                   color: .main,
                                                   challengeCnt: 0)
                    self.drawBlockArea(blocks: $0.matrices ?? [],
                                       owner: .friends,
                                       blockColor: .gray25)
                }
            })
            .disposed(by: bag)
    }
    
    private func bindChallengeFriendBlocks() {
        viewModel.output.challengeFriendBlocks
            .subscribe(onNext: { [weak self] friends in
                guard let self = self else { return }
                if !self.viewModel.output.friendVisible.value { return }
                friends.forEach {
                    self.mapVC.addFriendAnnotation(coordinate: [$0.latitude, $0.longitude],
                                                   profileImage: UIImage(named: "defaultThumbnail")!,
                                                   nickname: $0.nickname,
                                                   color: ChallengeColorType(rawValue: $0.challengeColor)?.primaryColor ?? .main,
                                                   challengeCnt: $0.challengeNumber)
                    self.drawBlockArea(blocks: $0.matrices,
                                       owner: .friends,
                                       blockColor: ChallengeColorType(rawValue: $0.challengeColor)?.blockColor ?? .gray25)
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods

extension WalkingVC {
    /// 기록 중 상태에 따라 일시정지, 멈춤, 재시작 버튼의 상태를 지정하는 함수
    private func setRecordBtnStatus(isWalking: Bool) {
        stopPlayView.isHidden = isWalking
        pauseBtn.isHidden = !isWalking
        mapVC.isWalking = isWalking
    }
}
