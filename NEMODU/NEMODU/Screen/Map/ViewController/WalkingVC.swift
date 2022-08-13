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
    
    private let recodeBaseView = UIView()
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
    
    private let recodeStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    
    private let blocksNumView = RecodeView()
        .then {
            $0.recodeValue.text = "0"
            $0.recodeTitle.text = "채운 칸의 수"
            $0.recodeSubtitle.text = "이번주 영역: 0칸"
        }
    
    private let distanceView = RecodeView()
        .then {
            $0.recodeValue.text = "0m"
            $0.recodeTitle.text = "거리"
        }
    
    private let timeView = RecodeView()
        .then {
            $0.recodeValue.text = "0:00"
            $0.recodeTitle.text = "시간"
        }
    
    private var secondTimeValue: Int = 0
    private let viewModel = WalkingVM()
    private let bag = DisposeBag()
    
    // TODO: - 서버 연결 후 수정
    private var weekBlockCnt = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        mapVC.updateStep()
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
        bindRecodeValue()
    }
}

// MARK: - Configure

extension WalkingVC {
    private func configureWalkingView() {
        addChild(mapVC)
        view.addSubviews([mapVC.view,
                          recodeBaseView])
        recodeBaseView.addSubviews([stopPlayView, pauseBtn, recodeStackView])
        [blocksNumView, distanceView, timeView].forEach {
            recodeStackView.addArrangedSubview($0)
        }
        stopPlayView.addSubviews([stopBtn, playBtn])
    }
}

// MARK: - Layout

extension WalkingVC {
    private func configureLayout() {
        mapVC.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(recodeBaseView.snp.top).offset(22 )
        }
        
        recodeBaseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(240)
        }
        
        mapVC.currentLocationBtn.snp.makeConstraints {
            $0.bottom.equalTo(recodeBaseView.snp.top).offset(-16)
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
        
        recodeStackView.snp.makeConstraints {
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
                self.setRecodeBtnStatus(isWalking: false)
                self.mapVC.stopUpdateStep()
            })
            .disposed(by: bag)
        
        // 기록 중단 버튼
        stopBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let recodeResultVC = RecodeResultVC()
                recodeResultVC.modalPresentationStyle = .fullScreen
                recodeResultVC.configureRecodeValue(blocks: self.mapVC.blocks,
                                                    weekBlockCnt: self.weekBlockCnt,
                                                    distance: self.mapVC.updateDistance.value,
                                                    second: self.secondTimeValue,
                                                    stepCnt: self.mapVC.stepCnt)
                self.mapVC.stopUpdateStep()
                self.present(recodeResultVC, animated: true)
            })
            .disposed(by: bag)
        
        // 기록 재시작 버튼
        playBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setRecodeBtnStatus(isWalking: true)
                self.mapVC.updateStep()
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension WalkingVC {
    func bindRecodeValue() {
        // 이동 거리 기록
        mapVC.updateDistance
            .asDriver()
            .drive(onNext: { [weak self] distance in
                guard let self = self else { return }
                self.distanceView.recodeValue.text = "\(distance)m"
            })
            .disposed(by: bag)
        
        // 이동 시간 기록
        viewModel.output.driver.asObservable()
            .subscribe(onNext: { [weak self] second in
                guard let self = self else { return }
                if self.mapVC.isWalking ?? false {
                    self.secondTimeValue += second
                    self.timeView.recodeValue.text
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
                self.blocksNumView.recodeValue.text = "\(blocksCnt)"
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods

extension WalkingVC {
    /// 기록 중 상태에 따라 일시정지, 멈춤, 재시작 버튼의 상태를 지정하는 함수
    private func setRecodeBtnStatus(isWalking: Bool) {
        stopPlayView.isHidden = isWalking
        pauseBtn.isHidden = !isWalking
        mapVC.isWalking = isWalking
    }
}
