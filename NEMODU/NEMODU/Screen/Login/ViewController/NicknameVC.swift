//
//  NicknameVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/12.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class NicknameVC: BaseViewController {
    private let titleLabel = UILabel()
        .then {
            $0.text = "닉네임을 설정해주세요!"
            $0.font = .title1
            $0.textColor = .gray900
        }
    
    private let messageLabel = UILabel()
        .then {
            $0.text = "입력하신 닉네임은 카카오 친구 포함 모든 사용자에게\n노출될 수 있습니다."
            $0.font = .body3
            $0.textColor = .gray700
            $0.setLineBreakMode()
        }
    
    private let nicknameTextField = UITextField()
        .then {
            $0.addLeftPadding()
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .gray50
            $0.font = .body3
            $0.textColor = .gray900
            $0.attributedPlaceholder = NSAttributedString(string: "공백없이 2~6 글자를 입력해주세요",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray500])
        }
    
    private let checkNicknameBtn = UIButton()
        .then {
            $0.backgroundColor = .main
            $0.setTitle("중복체크", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 8
            $0.titleLabel?.font = .body2
        }
    
    private let nicknameCntLabel = UILabel()
        .then {
            $0.text = "0 / 6"
            $0.textColor = .gray500
            $0.font = .caption1
            $0.textAlignment = .right
        }
    
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

extension NicknameVC {
    private func configureContentView() {
        view.addSubviews([titleLabel,
                          messageLabel,
                          nicknameTextField,
                          checkNicknameBtn,
                          nicknameCntLabel])
    }
}

// MARK: - Layout

extension NicknameVC {
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
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(42)
        }
        
        checkNicknameBtn.snp.makeConstraints {
            $0.centerY.equalTo(nicknameTextField.snp.centerY)
            $0.leading.equalTo(nicknameTextField.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(88)
            $0.height.equalTo(42)
        }
        
        nicknameCntLabel.snp.makeConstraints {
            $0.top.equalTo(checkNicknameBtn.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

// MARK: - Input

extension NicknameVC {
    
}

// MARK: - Output

extension NicknameVC {
    
}
