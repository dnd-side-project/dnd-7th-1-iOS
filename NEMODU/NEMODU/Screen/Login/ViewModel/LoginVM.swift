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
                    self.checkOriginUser()
                }
            }
        } else {
            // TODO: - 시뮬레이터용 Account 로그인(임시)
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    UserDefaults.standard.set(oauthToken?.accessToken, forKey: UserDefaults.Keys.kakaoAccessToken)
                    UserDefaults.standard.set(oauthToken?.refreshToken, forKey: UserDefaults.Keys.kakaoRefreshToken)
                    self.checkOriginUser()
                }
            }
        }
    }
    
    /// kakao accessToken으로 기존 유저인지 서버에 판단 요청
    func checkOriginUser() {
        let path = "auth/check/origin"
        let resource = urlResource<Bool>(path: path)

        AuthAPI.shared.checkOriginUser(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let isOriginUser):
                    isOriginUser
                    ? owner.nemoduLogin()
                    : owner.output.isOriginUser.accept(false)
                }
            })
            .disposed(by: bag)
    }
    
    /// 토큰 만료 후 로그인 시 토큰을 발급받는 메서드
    func nemoduLogin() {
        let path = "login"
        let resource = urlResource<NicknameModel>(path: path)
        AuthAPI.shared.loginRequest(with: resource)
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
