//
//  TermsConditionsAgreementVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/08.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

import SafariServices

class TermsConditionsAgreementVC: BaseViewController {
    
    // MARK: - UI components
    
    private let nemoduImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "logo_black")
        }
    private let messageLabel = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .title2
            $0.text = "함께 움직이며 나의 활동반경을 \n네모들로 채워나가 보아요!"
            $0.textColor = .gray900
            $0.textAlignment = .center
        }
    
    private let agreeAllButton = UIButton()
    private let agreeAllImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "checkCircle")?.withTintColor(.gray300, renderingMode: .alwaysTemplate)
            $0.tintColor = .gray300
        }
    private let agreeAllLabel = UILabel()
        .then {
            $0.text = "전체 동의"
            $0.textColor = .gray800
            $0.font = .title3M
        }
    private let lineView = UIView()
        .then {
            $0.backgroundColor = .gray300
        }
    
    private let agreeListStackView = UIStackView()
        .then {
            $0.spacing = 0.0
            $0.axis = .vertical
            $0.distribution = .fill
        }
    private let serviceTermsConditionsAgreeView = TermsConditionsAgreeView()
        .then {
            $0.setTitle(title: "(필수) 서비스 이용 약관")
        }
    private let privacyTermsConditionsAgreeView = TermsConditionsAgreeView()
        .then {
            $0.setTitle(title: "(필수) 개인 정보 수집 및 이용 동의")
        }
    private let locationTermsConditionsAgreeView = TermsConditionsAgreeView()
        .then {
            $0.setTitle(title: "(필수) 위치 기반 서비스 약관 동의")
        }
    
    private let startButton = UIButton()
        .then {
            $0.setTitle("네모두 시작하기", for: .normal)
            $0.titleLabel?.font = .headline1
            $0.tintColor = .secondary
            $0.setTitleColor(.gray400, for: .normal)
            
            $0.backgroundColor = .gray100
            
            $0.layer.cornerRadius = 48 / 2
            $0.addShadow()
            
            $0.isEnabled = false
        }
    
    // MARK: - Variables and Properties
    
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    // MARK: - Functions
    
    private func showTermsConditionsWebPage(url: String) {
        guard let url = URL(string: url) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .main
        
        present(safariViewController, animated: true, completion: nil)
    }
    
    private func toggleAgreeAllStatus(agreedAll: Bool) {
        agreeAllButton.isSelected = agreedAll
        agreeAllImageView.tintColor = agreedAll ? .main : .gray300
        
        startButton.setTitleColor(agreedAll ? .secondary : .gray400, for: .normal)
        startButton.backgroundColor = agreedAll ? .main: .gray100
        startButton.isEnabled = agreedAll
    }
    
}

// MARK: - Layout

extension TermsConditionsAgreementVC {
    
    private func configureLayout() {
        view.addSubviews([nemoduImageView,
                          messageLabel,
                          agreeAllButton,
                          lineView,
                          agreeListStackView,
                          startButton])

        agreeAllButton.addSubviews([agreeAllImageView, agreeAllLabel])
        
        [serviceTermsConditionsAgreeView,
         privacyTermsConditionsAgreeView,
         locationTermsConditionsAgreeView].forEach {
            agreeListStackView.addArrangedSubview($0)
        }
        
        
        nemoduImageView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60.0)
        }
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(nemoduImageView)
            $0.top.equalTo(nemoduImageView.snp.bottom).offset(36.0)
            $0.horizontalEdges.equalTo(view)
        }
        
        agreeAllButton.snp.makeConstraints {
            $0.left.equalTo(lineView.snp.left)
            $0.bottom.equalTo(lineView.snp.top).offset(-11.0)
        }
        agreeAllImageView.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            
            $0.top.left.bottom.equalTo(agreeAllButton)
        }
        agreeAllLabel.snp.makeConstraints {
            $0.centerY.equalTo(agreeAllImageView)
            $0.left.equalTo(agreeAllImageView.snp.right).offset(8.0)
            $0.right.equalTo(agreeAllButton.snp.right)
        }
        lineView.snp.makeConstraints {
            $0.height.equalTo(1.0)
            
            $0.horizontalEdges.equalTo(startButton)
            $0.bottom.equalTo(agreeListStackView.snp.top).offset(-8.0)
        }
        
        agreeListStackView.snp.makeConstraints {
            $0.left.equalTo(startButton.snp.left).offset(8.0)
            $0.right.equalTo(startButton.snp.right)
            $0.bottom.equalTo(startButton.snp.top).offset(-60.0)
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(48.0)
            
            $0.horizontalEdges.equalTo(view).inset(24.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24.0)
        }
    }
    
}

// MARK: - Input

extension TermsConditionsAgreementVC {
    
    private func bindButton() {
        let agreeViewList = [serviceTermsConditionsAgreeView,
                             privacyTermsConditionsAgreeView,
                             locationTermsConditionsAgreeView]
        
        agreeAllButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.agreeAllButton.isSelected.toggle()
                let isAgreeAllButtonSelected = self.agreeAllButton.isSelected
                self.toggleAgreeAllStatus(isAgree: isAgreeAllButtonSelected)
                for agreeView in agreeViewList {
                    agreeView.isAgreeDetailTermsConditions(isAgree: isAgreeAllButtonSelected)
                }
            })
            .disposed(by: bag)
        
        agreeViewList.forEach { agreeView in
            agreeView.checkStatusButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                // 개별 이용약관 체크버튼 토글
                agreeView.isAgreeDetailTermsConditions(isAgree: !agreeView.checkStatusButton.isSelected)
                
                // 전체 이용약관 체크버튼 활성화 유무 확인
                var isAgreedAll = true
                for agreeView in agreeViewList {
                    if agreeView.checkStatusButton.isSelected == false {
                        isAgreedAll = false
                        break
                    }
                }
                self.toggleAgreeAllStatus(agreedAll: isAgreedAll)
            })
            .disposed(by: bag)
            
        }
        
        typealias ButtonType = (button: UIButton, webLink: TermsConditionsWebLink)
        let buttonTypeList: [ButtonType] = [(serviceTermsConditionsAgreeView.seeDetailTermsConditionsButton, TermsConditionsWebLink.service),
                                            (privacyTermsConditionsAgreeView.seeDetailTermsConditionsButton, TermsConditionsWebLink.privacy),
                                            (locationTermsConditionsAgreeView.seeDetailTermsConditionsButton, TermsConditionsWebLink.location)]
        
        buttonTypeList.forEach { buttonType in
            buttonType.button.rx.tap
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.showTermsConditionsWebPage(url: buttonType.webLink.url)
                })
                .disposed(by: bag)
        }
        
        startButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                // TODO: - 네모두 시작하기 버튼 바인딩
                print("startButton - 네모두 시작하기 pressed")
            })
            .disposed(by: bag)
    }
    
}
