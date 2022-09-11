//
//  LoginVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/26.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class LoginVC: BaseViewController {
    private let sloganImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "slogan")
        }
    
    private let logoImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "logo_black")
        }
    
    private let kakaoLoginBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "kakaoBtn"), for: .normal)
        }
    
    private let viewModel = LoginVM()
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
        bindLoginBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindKakaoLoginResult()
    }
    
}

// MARK: - Configure

extension LoginVC {
    private func configureContentView() {
        view.addSubviews([sloganImageView, logoImageView, kakaoLoginBtn])
    }
}

// MARK: - Layout

extension LoginVC {
    private func configureLayout() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        sloganImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(logoImageView.snp.top).offset(-6)
            $0.width.equalTo(174)
            $0.height.equalTo(66)
        }
        
        kakaoLoginBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-41)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
}

// MARK: - Custom Methods

extension LoginVC {
    private func presentNicknameVC() {
        let nicknameVC = NicknameVC()
        nicknameVC.modalPresentationStyle = .fullScreen
        self.present(nicknameVC, animated: true)
    }
}

// MARK: - Input

extension LoginVC {
    private func bindLoginBtn() {
        kakaoLoginBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.kakaoLogin()
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension LoginVC {
    private func bindKakaoLoginResult() {
        viewModel.output.isOriginUser
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isOriginUser in
                guard let self = self else { return }
                isOriginUser
                ? self.setTBCtoRootVC()
                : self.presentNicknameVC()
            })
            .disposed(by: bag)
    }
}
