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
            $0.text = "기록이 시작됩니다."
            $0.font = .headline1
            $0.textAlignment = .center
            $0.textColor = .white
        }
    
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
                          message])
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-136)
            $0.centerX.equalToSuperview()
        }
    }
}
