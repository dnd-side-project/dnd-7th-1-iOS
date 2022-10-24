//
//  LocationSettingVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/22.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class LocationSettingVC: BaseViewController {
    private let titleLabel = UILabel()
        .then {
            $0.text = "친구에게\n나의 위치를 공개할까요?"
            $0.font = .title1
            $0.textColor = .gray900
            $0.setLineBreakMode()
        }
    
    private let messageLabel = UILabel()
        .then {
            $0.text = "공개 시 나의 기록이 친구의 지도위에 표시되고,\n이후 지도 필터에서도 설정 변경이 가능합니다."
            $0.font = .body3
            $0.textColor = .gray700
            $0.setLineBreakMode()
        }
    
    private let subTitleLabel = UILabel()
        .then {
            $0.text = "내 위치 공개"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let permissionToggle = UISwitch()
        .then {
            $0.onTintColor = .main
            $0.isOn = true
        }
    
    private let exampleImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "locationPublic")
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
        bindToggleBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension LocationSettingVC {
    private func configureContentView() {
        view.backgroundColor = .clear
        view.addSubviews([titleLabel,
                          messageLabel,
                          subTitleLabel,
                          permissionToggle,
                          exampleImageView])
        
    }
}

// MARK: - Layout

extension LocationSettingVC {
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        permissionToggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(subTitleLabel.snp.centerY)
        }
        
        exampleImageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(52)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Input

extension LocationSettingVC {
    private func bindToggleBtn() {
        permissionToggle.rx.isOn
            .changed
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                UIView.transition(with: owner.exampleImageView,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve) {
                    owner.exampleImageView.image = status
                    ? UIImage(named: "locationPublic")
                    : UIImage(named: "locationPrivate")
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension LocationSettingVC {
    
}
