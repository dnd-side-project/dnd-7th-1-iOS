//
//  AlertVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/25.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class AlertVC: BaseViewController {
    private let alertBaseView = UIView()
        .then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.addShadow()
        }
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 24
            $0.alignment = .center
        }
    
    private let alertImage = UIImageView()
        .then {
            $0.image = UIImage(named: "warning")
        }
    
    private let alertTitle = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .title3SB
            $0.textColor = .gray900
            $0.textAlignment = .center
        }
    
    private let alertMessage = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .body2
            $0.textColor = .gray900
            $0.textAlignment = .center
        }
    
    private let btnStackView = UIStackView()
        .then {
            $0.spacing = 8
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private let highlightBtn = UIButton()
        .then {
            $0.titleLabel?.font = .body2
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .main
            $0.layer.cornerRadius = 8
        }
    
    private let normalBtn = UIButton()
        .then {
            $0.titleLabel?.font = .body2
            $0.setTitleColor(.gray700, for: .normal)
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension AlertVC {
    private func configureContentView() {
        view.backgroundColor = .backgroundBlack
        view.addSubview(alertBaseView)
        alertBaseView.addSubviews([baseStackView,
                                   btnStackView])
        let alertBase = [alertImage, alertTitle] + ((alertMessage.text != nil) ? [alertMessage] : [])
        alertBase.forEach {
            baseStackView.addArrangedSubview($0)
        }
    }
    
    private func setTitle(of alertType: AlertType) {
        alertTitle.text = alertType.alertTitle
    }
    
    private func setMessage(of alertType: AlertType) {
        alertMessage.text = alertType.alertMessage
    }
    
    private func setBtn(of alertType: AlertType) {
        highlightBtn.setTitle(alertType.highlightBtnTitle, for: .normal)
        normalBtn.setTitle(alertType.normalBtnTitle, for: .normal)
        switch alertType {
        // 버튼 한 개
        case .defaultNetworkError, .requestLocationAuthority, .realTimeChallenge, .createWeekChallenge, .sendMailError:
            btnStackView.addArrangedSubview(highlightBtn)
        // 버튼 세로 두 개
        case .requestMotionAuthority:
            btnStackView.axis = .vertical
            [highlightBtn, normalBtn].forEach {
                btnStackView.addArrangedSubview($0)
            }
        // 버튼 가로 두 개
        case .recordNetworkError, .minimumBlocks, .speedWarning, .discardChanges, .deleteFriend:
            btnStackView.axis = .horizontal
            [normalBtn, highlightBtn].forEach {
                btnStackView.addArrangedSubview($0)
            }
        }
    }
    
    /// AlertType에 따른 알람창 구현
    func configureAlert(of alertType: AlertType,
                        targetVC: UIViewController,
                        highlightBtnAction: Selector,
                        normalBtnAction: Selector?) {
        setTitle(of: alertType)
        setMessage(of: alertType)
        setBtn(of: alertType)
        highlightBtn.addTarget(targetVC,
                               action: highlightBtnAction,
                               for: .touchUpInside)
        
        guard let normalBtnAction = normalBtnAction else { return }
        normalBtn.addTarget(targetVC,
                            action: normalBtnAction,
                            for: .touchUpInside)
    }
    
    /// Error Alert 구현
    func configureErrorAlert(targetVC: UIViewController,
                             title: String,
                             confirmEvent: Selector) {
        alertTitle.text = title
        highlightBtn.setTitle("확인", for: .normal)
        highlightBtn.addTarget(targetVC,
                               action: confirmEvent,
                               for: .touchUpInside)
        btnStackView.addArrangedSubview(highlightBtn)
    }
}

// MARK: - Layout

extension AlertVC {
    private func configureLayout() {
        alertBaseView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
            $0.centerY.equalToSuperview()
        }
        
        baseStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        btnStackView.snp.makeConstraints {
            $0.top.equalTo(baseStackView.snp.bottom).offset(36)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.bottom.equalToSuperview().offset(-24)
        }
        
        highlightBtn.snp.makeConstraints {
            $0.height.equalTo(43)
        }
        
        normalBtn.snp.makeConstraints {
            $0.height.equalTo(43)
        }
    }
}
