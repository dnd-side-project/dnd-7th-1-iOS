//
//  LoginVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/07.
//

import Foundation
import RxCocoa
import RxSwift
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class LoginVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var isOriginUser = PublishRelay<Bool>()
        var goToTabBar = PublishRelay<Bool>()
    }
    
    // MARK: - Init
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Helpers

extension LoginVM {}

// MARK: - Input

extension LoginVM: Input {
    func bindInput() { }
}

// MARK: - Output

extension LoginVM: Output {
    func bindOutput() { }
}

// MARK: - Networking

extension LoginVM {
    /// 카카오 로그인 버튼을 눌렀을 때 카카오 토큰을 저장하고 소셜 로그인을 진행하는 메서드
    func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    var scopes = [String]()
                    scopes.append("friends")
                    scopes.append("account_email")
                    
                    UserApi.shared.me() { (user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            UserDefaults.standard.set(oauthToken?.accessToken, forKey: UserDefaults.Keys.kakaoAccessToken)
                            UserDefaults.standard.set(oauthToken?.refreshToken, forKey: UserDefaults.Keys.kakaoRefreshToken)
                            UserDefaults.standard.set(user?.id, forKey: UserDefaults.Keys.kakaoUserID)
                            self.socialLogin(type: .kakao)
                        }
                    }
                }
            }
        } else {
            // TODO: - 시뮬레이터용 Account 로그인(임시)
            UserApi.shared.me { user, error in
                if let error = error {
                    print(error)
                } else {
                    var scopes = [String]()
                    scopes.append("friends")
                    scopes.append("account_email")
                    
                    UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (oauthToken, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            UserApi.shared.me() { (user, error) in
                                if let error = error {
                                    print(error)
                                }
                                else {
                                    UserDefaults.standard.set(oauthToken?.accessToken, forKey: UserDefaults.Keys.kakaoAccessToken)
                                    UserDefaults.standard.set(oauthToken?.refreshToken, forKey: UserDefaults.Keys.kakaoRefreshToken)
                                    UserDefaults.standard.set(user?.id, forKey: UserDefaults.Keys.kakaoUserID)
                                    self.socialLogin(type: .kakao)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// 소셜 로그인을 요청하는 메서드
    func socialLogin(type: LoginType) {
        let path = "auth/social/login?type=\(type.rawValue)"
        let resource = urlResource<SocialLoginResponseModel>(path: path)
        
        AuthAPI.shared.socialLoginRequest(with: resource,
                                          token: type.token)
        .withUnretained(self)
        .subscribe(onNext: { owner, result in
            switch result {
            case .failure(let error):
                owner.apiError.onNext(error)
            case .success(let data):
                UserDefaults.standard.set(type.rawValue, forKey: UserDefaults.Keys.loginType)
                UserDefaults.standard.set(data.email, forKey: UserDefaults.Keys.email)
                UserDefaults.standard.set(data.picturePath, forKey: UserDefaults.Keys.picturePath)
                UserDefaults.standard.set(data.pictureName, forKey: UserDefaults.Keys.pictureName)
                
                owner.output.isOriginUser.accept(data.signed)
                print("소셜 로그인 성공")
            }
        })
        .disposed(by: bag)
    }
    
    /// 토큰 만료 후 로그인 시 토큰을 발급받는 메서드
    func nemoduLogin() {
        // TODO: - fatalError 처리
        guard let email = UserDefaults.standard.string(forKey: UserDefaults.Keys.email),
              let loginType = UserDefaults.standard.string(forKey: UserDefaults.Keys.loginType),
              let token = LoginType(rawValue: loginType)?.token
        else { fatalError() }
        
        let path = "login"
        let resource = urlResource<NicknameModel>(path: path)
        let param = LoginRequestModel(email: email,
                                      loginType: loginType)
        
        AuthAPI.shared.loginRequest(with: resource,
                                    token: token,
                                    param: param.param)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    UserDefaults.standard.set(data.nickname, forKey: UserDefaults.Keys.nickname)
                    owner.output.goToTabBar.accept(true)
                    print("네모두 로그인 성공")
                }
            })
            .disposed(by: bag)
    }
}
