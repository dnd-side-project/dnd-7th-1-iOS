//
//  CountdownVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/16.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Lottie

class CountdownVC: BaseViewController {
    private let animationView = AnimationView(name: "countdown")
        .then {
            $0.play()
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFill
        }
    
    private let timerNumLabel = UILabel()
        .then {
            $0.text = "3"
            $0.font = .PretendardExtraBold(size: 128)
            $0.textColor = .main
        }
    
    private let message = UILabel()
        .then {
            $0.text = "주변을 돌아다니며\n네모를 채워나가보세요!"
            $0.setLineBreakMode()
            $0.font = .headline1
            $0.textAlignment = .center
            $0.textColor = .white
        }
    
    private let tipTitleLabel = UILabel()
        .then {
            $0.text = "TIP!"
            $0.font = .body3
            $0.textColor = .main
            $0.textAlignment = .center
        }
    
    private let tipMessageLabel = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .body3
            $0.textColor = .white
            $0.textAlignment = .center
        }
    
    private let tips = [
        "나의 영역은 일주일 마다 리셋됩니다.",
        "5칸 이상 부터 기록됩니다.",
        "지도 필터에서 내 위치를 보이지않게 할 수 있습니다.",
        "동시에 진행가능한 챌린지는 최대 3개입니다.",
        "자전거나 자동차를 이용하면 기록이 중지됩니다.",
        "지금까지 누적한 칸 수는\n마이페이지에서 확인할 수 있습니다."
    ]
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
        configureTimer()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
}

// MARK: - Configure

extension CountdownVC {
    private func configureContentView() {
        view.backgroundColor = .secondary
        
        view.addSubviews([animationView,
                          timerNumLabel,
                          message,
                          tipTitleLabel,
                          tipMessageLabel])
        
        tipMessageLabel.text = tips.randomElement()
    }
    
    private func configureTimer() {
        let timer = Observable<Int>
            .interval(.milliseconds(1500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] timeNum in
                guard let self = self else { return }
                self.timerNumLabel.text = String(2 - timeNum)
            })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            timer.dispose()
            guard let pvc = self.presentingViewController else { return }
            
            self.dismiss(animated: false) {
                let walkingVC = WalkingVC()
                walkingVC.modalPresentationStyle = .fullScreen
                pvc.present(walkingVC, animated: false)
            }
        }
    }
}

// MARK: - Layout

extension CountdownVC {
    private func configureLayout() {
        animationView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(125)
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().offset(-38)
            $0.height.equalTo(animationView.snp.width)
        }
        
        timerNumLabel.snp.makeConstraints {
            $0.center.equalTo(animationView)
        }
        
        message.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-160)
            $0.centerX.equalToSuperview()
        }

        tipTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(tipMessageLabel.snp.top)
            $0.centerX.equalToSuperview()
        }

        tipMessageLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
