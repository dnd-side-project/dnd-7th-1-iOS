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
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.backgroundColor = .gray50
            $0.font = .body3
            $0.textColor = .gray900
            $0.returnKeyType = .done
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
        checkNicknameValidation()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindNicknameTextField()
        bindTextFieldActivate()
    }
    
}

// MARK: - Configure

extension NicknameVC {
    private func configureContentView() {
        view.addSubviews([titleLabel,
                          messageLabel,
                          nicknameTextField,
                          checkNicknameBtn,
                          nicknameCntLabel,
                          validationStackView])
        [validationImageView, validationLabel].forEach {
            validationStackView.addArrangedSubview($0)
        }
        
        nicknameTextField.delegate = self
    }
    
    private func setValidationView(_ nicknameType: NicknameType) {
        self.validationStackView.isHidden = false
        validationLabel.text = nicknameType.message
        validationLabel.textColor = nicknameType.tintColor
        validationImageView.image = nicknameType.image
        nicknameTextField.layer.borderColor = nicknameType.tintColor.cgColor
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
        
        validationStackView.snp.makeConstraints {
            $0.centerY.equalTo(nicknameCntLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(14)
        }
    }
}

// MARK: - Input

extension NicknameVC {
    private func checkNicknameValidation() {
        checkNicknameBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let nicknameCnt = self.nicknameTextField.text?.count
                else { return }
                nicknameCnt < 2 || nicknameCnt > 6
                ? self.setValidationView(.countError)
                : print()// TODO: - 서버에서 중복된 닉네임인지 확인
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension NicknameVC {
    private func bindNicknameTextField() {
        nicknameTextField.rx.text
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] text in
                guard let self = self, let text = text else { return }
                self.validationStackView.isHidden = true
                if text.count > self.maxTextCnt {
                    self.nicknameTextField.text?.removeLast()
                    self.setValidationView(.countError)
                } else {
                    self.nicknameCntLabel.text = "\(text.count) / \(self.maxTextCnt)"
                }
            })
            .disposed(by: bag)
        
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
    
    private func bindTextFieldActivate() {
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

extension NicknameVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
