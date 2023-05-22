//
//  EnterVC.swift
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

class EnterVC: BaseViewController {
    private let iconImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "Icon")
        }
    
    private let logoImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "logo_black")
        }
    
    private let enterMessgae = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .title2
            $0.textColor = .gray900
        }
    
    private let enterBtn = UIButton()
        .then {
            $0.titleLabel?.font = .headline1
            $0.tintColor = .secondary
            $0.setTitleColor(.secondary, for: .normal)
            $0.layer.cornerRadius = 48 / 2
            $0.backgroundColor = .main
            $0.addShadow()
            $0.setTitle("네모두 시작하기", for: .normal)
            $0.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
        }
    
    private let viewModel = EnterVM()
    
    var userDataModel: UserDataModel?
    
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
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindAPIErrorAlert(viewModel)
        changeRootVC()
    }
    
    override func bindLoading() {
        super.bindLoading()
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.loading(loading: isLoading)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure

extension EnterVC {
    private func configureContentView() {
        view.addSubviews([iconImageView,
                          logoImageView,
                          enterMessgae,
                          enterBtn])
        enterMessgae.text = "반가워요 \(String(describing: UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""))님,\n네모두에 오신 것을\n환영합니다!\n\n함께 움직이며 나의 활동반경을\n네모들로 채워나가 보아요!"
    }
}

// MARK: - Layout

extension EnterVC {
    private func configureLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(140)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        enterMessgae.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(72)
            $0.leading.equalToSuperview().offset(24)
        }
        
        enterBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(48)
        }
    }
}

// MARK: - Input

extension EnterVC {
    private func bindBtn() {
        enterBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let userDataModel = self.userDataModel else { return }
                self.viewModel.requestSignup(userDataModel)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension EnterVC {
    private func changeRootVC() {
        viewModel.output.isLoginSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setTBCtoRootVC()
            })
            .disposed(by: disposeBag)
    }
}
