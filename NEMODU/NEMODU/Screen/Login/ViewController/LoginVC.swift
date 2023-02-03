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
import AuthenticationServices

class LoginVC: BaseViewController {
    private let sloganImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "slogan")
        }
    
    private let logoImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "logo_black")
        }
    
    private let kakaoLoginBtn = LoginBtn(image: UIImage(named: "kakaoIcon"),
                                         title: "카카오로 시작하기",
                                         backgroundColor: UIColor(red: 254.0/255.0,
                                                                  green: 229.0/255.0,
                                                                  blue: 0.0/255.0,
                                                                  alpha: 1.0),
                                         textColor: UIColor(red: 25.0/255.0,
                                                            green: 25.0/255.0,
                                                            blue: 25.0/255.0,
                                                            alpha: 1.0))
    
    
    private let appleLoginBtn = LoginBtn(image: UIImage(named: "appleIcon"),
                                         title: "Apple로 계속하기",
                                         backgroundColor: .black,
                                         textColor: .white)
    
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
        bindLoginResult()
    }
    
}

// MARK: - Configure

extension LoginVC {
    private func configureContentView() {
        view.addSubviews([sloganImageView,
                          logoImageView,
                          appleLoginBtn,
                          kakaoLoginBtn])
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
        
        appleLoginBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(kakaoLoginBtn.snp.top).offset(-14)
            $0.height.equalTo(45)
        }
        
        kakaoLoginBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(45)
        }
    }
}

// MARK: - Input

extension LoginVC {
    private func bindLoginBtn() {
        appleLoginBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.appleLogin()
            })
            .disposed(by: bag)
        
        kakaoLoginBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.kakaoLogin()
            })
            .disposed(by: bag)
    }
    
    @objc func appleLogin() {
        // TODO: 분기 조건 추가
        true
        ? defaultLogin()
        : performExistingAccountSetupFlows()
    }
    
    func defaultLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func performExistingAccountSetupFlows() {
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - Output

extension LoginVC {
    private func bindLoginResult() {
        viewModel.output.isOriginUser
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isOriginUser in
                guard let self = self else { return }
                isOriginUser
                ? self.setTBCtoRootVC()
                : self.navigationController?.pushViewController(UserInfoSettingVC(), animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let appleToken = String(data: appleIDCredential.identityToken!, encoding: .utf8) else { return }
            UserDefaults.standard.set(appleToken, forKey: UserDefaults.Keys.appleToken)
            
            // 소셜 로그인 진행
            viewModel.socialLogin(type: .apple)
        case let passwordCredential as ASPasswordCredential:
            // TODO: -
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print(username, password)
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        dump(error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let currentUserIdentifier = UserDefaults.standard.string(forKey: UserDefaults.Keys.appleToken) else { return false }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        appleIDProvider.getCredentialState(forUserID: currentUserIdentifier) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                break
            case .revoked, .notFound:
                // TODO: - 알람?
                break
            default:
                break
            }
        }
        return true
    }
    
}
