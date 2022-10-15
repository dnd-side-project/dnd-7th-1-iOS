//
//  NicknameCheckView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/14.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NicknameCheckView: BaseView {
    var nicknameTextField = NemoduTextField()
        .then {
            $0.placeholder = "공백없이 2~6 글자를 입력해주세요"
            $0.returnKeyType = .done
        }
    
    let nicknameCheckBtn = UIButton()
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
    
    private let validationStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
        }
    
    private let validationLabel = UILabel()
        .then {
            $0.font = .caption1
        }
    
    private let validationImageView = UIImageView(frame: CGRect(origin: .zero,
                                                                size: CGSize(width: 12, height: 12)))
    
    private let maxTextCnt = 6
    private let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    private let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
    private let bag = DisposeBag()
    
    override func configureView() {
        super.configureView()
        configureContentView()
        bindTextViewActivate()
        bindNicknameTextField()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
}

// MARK: - Configure

extension NicknameCheckView {
    private func configureContentView() {
        addSubviews([nicknameTextField,
                     nicknameCheckBtn,
                     validationStackView,
                     nicknameCntLabel])
        [validationImageView, validationLabel].forEach {
            validationStackView.addArrangedSubview($0)
        }
        nicknameTextField.delegate = self
        nicknameCntLabel.text = "0 / \(maxTextCnt)"
    }
    
    func setValidationView(_ nicknameType: NicknameType) {
        validationStackView.isHidden = false
        validationLabel.text = nicknameType.message
        validationLabel.textColor = nicknameType.tintColor
        validationImageView.image = nicknameType.image
        nicknameTextField.layer.borderColor = nicknameType.tintColor.cgColor
    }
}

// MARK: - Layout

extension NicknameCheckView {
    private func configureLayout() {
        nicknameTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        nicknameCheckBtn.snp.makeConstraints {
            $0.centerY.equalTo(nicknameTextField.snp.centerY)
            $0.leading.equalTo(nicknameTextField.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(88)
            $0.height.equalTo(nicknameTextField.snp.height)
        }
        
        nicknameCntLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameCheckBtn.snp.bottom).offset(8)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        validationStackView.snp.makeConstraints {
            $0.centerY.equalTo(nicknameCntLabel.snp.centerY)
            $0.leading.equalToSuperview()
            $0.height.equalTo(14)
        }
    }
}

// MARK: - Input

extension NicknameCheckView {
    private func bindNicknameTextField() {
        // text count
        nicknameTextField.rx.text
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] text in
                guard let self = self,
                        let text = text else { return }
                self.validationStackView.isHidden = true
                if text.count > self.maxTextCnt {
                    self.nicknameTextField.text?.removeLast()
                    self.setValidationView(.countError)
                } else {
                    self.nicknameCntLabel.text = "\(text.count) / \(self.maxTextCnt)"
                }
            })
            .disposed(by: bag)
        
        // border color
        nicknameTextField.rx.text
            .changed
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nicknameTextField.layer.borderColor = UIColor.secondary.cgColor
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension NicknameCheckView  {
    private func bindTextViewActivate() {
        keyboardWillShow
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nicknameTextField.layer.borderColor = UIColor.secondary.cgColor
            })
            .disposed(by: bag)

        keyboardWillHide
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nicknameTextField.layer.borderColor = UIColor.clear.cgColor
            })
            .disposed(by: bag)
    }
}

// MARK: - UITextFieldDelegate

extension NicknameCheckView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
