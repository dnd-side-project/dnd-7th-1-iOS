//
//  TermsConditionsVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/25.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

import SafariServices

class TermsConditionsVC: BaseViewController {
    
    // MARK: - UI components
    
    private let navigationBar = NavigationBar()
    
    private let termsConditionsListStackView = UIStackView()
        .then {
            $0.spacing = 0
            $0.axis = .vertical
            $0.distribution = .equalCentering
        }
    private let serviceTermsConditionsButton = ArrowBtn(title: "서비스 이용 약관")
    private let privacyTermsConditionsButton = ArrowBtn(title: "개인 정보 수집 및 이용 동의")
    private let locationTermsConditionsButton = ArrowBtn(title: "위치 기반 서비스 약관")
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
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
    
}

// MARK: - Configure

extension TermsConditionsVC {
    
    private func configureNavigationBar() {
        navigationBar.naviType = .push
        navigationBar.configureNaviBar(targetVC: self,
                                 title: "이용 약관")
        navigationBar.configureBackBtn(targetVC: self)
    }
    
}

// MARK: - Layout

extension TermsConditionsVC {
    
    private func configureLayout() {
        view.addSubviews([termsConditionsListStackView])
        [serviceTermsConditionsButton,
         privacyTermsConditionsButton,
         locationTermsConditionsButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(56.0)
            }
            
            termsConditionsListStackView.addArrangedSubview($0)
        }
        termsConditionsListStackView.addHorizontalSeparators(color: .gray50, height: 1)
        
        termsConditionsListStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view)
        }
    }
    
}

// MARK: - Input

extension TermsConditionsVC {
    
    private func bindButton() {
        typealias ButtonType = (button: ArrowBtn, webLink: TermsConditionsWebLink)
        let buttonTypeList: [ButtonType] = [(serviceTermsConditionsButton, TermsConditionsWebLink.service),
                                            (privacyTermsConditionsButton, TermsConditionsWebLink.privacy),
                                            (locationTermsConditionsButton, TermsConditionsWebLink.location)]
        
        buttonTypeList.forEach { buttonType in
            buttonType.button.rx.tap
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.showTermsConditionsWebPage(url: buttonType.webLink.url)
                })
                .disposed(by: disposeBag)
        }
    }
    
}
