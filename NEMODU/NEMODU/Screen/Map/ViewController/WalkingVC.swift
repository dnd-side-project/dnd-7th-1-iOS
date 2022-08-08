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
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.stopPlayView.isHidden = false
                self.pauseBtn.isHidden = true
                self.mapVC.isWalking = false
            })
            .disposed(by: bag)
        
        // 기록 중단 버튼
        stopBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                // TODO: - 기록 확인 화면 연결
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
        
        // 기록 재시작 버튼
        playBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.stopPlayView.isHidden = true
                self.pauseBtn.isHidden = false
                self.mapVC.isWalking = true
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension WalkingVC {
    
}
