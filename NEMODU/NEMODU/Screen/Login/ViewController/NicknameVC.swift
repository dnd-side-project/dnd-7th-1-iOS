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
    
    private let nicknameCheckView = NicknameCheckView()
    var viewModel: UserInfoSettingVM?
    
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
        bindNextBtn()
        bindValidationView()
    }
    
}

// MARK: - Configure

extension NicknameVC {
    private func configureContentView() {
        view.addSubviews([titleLabel,
                          messageLabel,
                          nicknameCheckView])
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
        
        nicknameCheckView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(64)
        }
    }
}

// MARK: - Input

extension NicknameVC {
    /// 닉네임 유효성 검사를 요청하는 메서드
    private func checkNicknameValidation() {
        nicknameCheckView.nicknameCheckBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let viewModel = self.viewModel,
                      let nickname = self.nicknameCheckView.nicknameTextField.text
                else { return }
                nickname.count < 2 || nickname.count > 6
                ? self.nicknameCheckView.setValidationView(.countError)
                : viewModel.getNicknameValidation(nickname: nickname)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension NicknameVC {
    /// 닉네임 값이 변경되었을 때 다음 버튼을 비활성화 시키는 메서드
    private func bindNextBtn() {
        nicknameCheckView.nicknameTextField.rx.text
            .changed
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let viewModel = self.viewModel
                else { return }
                viewModel.output.isNextBtnActive.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    /// 사용 가능한 닉네임인지 판단 후 상태에 따라 view를 구성하는 메서드
    private func bindValidationView() {
        guard let viewModel = viewModel else { return }

        viewModel.output.isValidNickname
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValid in
                guard let self = self,
                      let nickname = self.nicknameCheckView.nicknameTextField.text
                else { return }
                self.nicknameCheckView.setValidationView(isValid ? .available : .notAvailable)
                if isValid {
                    UserDefaults.standard.set(nickname, forKey: UserDefaults.Keys.nickname)
                }
            })
            .disposed(by: disposeBag)
    }
}
