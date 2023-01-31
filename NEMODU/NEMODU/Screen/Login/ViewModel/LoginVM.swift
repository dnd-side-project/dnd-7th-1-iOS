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
    /// 카카오 로그인버튼을 눌렀을 때 카카오 토큰을 저장하고 기존 유저인지 판단 메서드를 호출하는 메서드
    func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    UserDefaults.standard.set(oauthToken?.accessToken, forKey: UserDefaults.Keys.kakaoAccessToken)
                    UserDefaults.standard.set(oauthToken?.refreshToken, forKey: UserDefaults.Keys.kakaoRefreshToken)
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
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// 토큰 만료 후 로그인 시 토큰을 발급받는 메서드
    func nemoduLogin(type: LoginType) {
        // TODO: - fatalError 처리
        guard let email = UserDefaults.standard.string(forKey: UserDefaults.Keys.email) else { fatalError() }
        let path = "login"
        let resource = urlResource<NicknameModel>(path: path)
        let param = LoginRequestModel(email: email,
                                      loginType: type.rawValue)
        
        AuthAPI.shared.loginRequest(with: resource,
                                    token: type.token,
                                    param: param.param)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    UserDefaults.standard.set(data.nickname, forKey: UserDefaults.Keys.nickname)
                    owner.output.isOriginUser.accept(true)
                }
            })
            .disposed(by: bag)
    }
}
