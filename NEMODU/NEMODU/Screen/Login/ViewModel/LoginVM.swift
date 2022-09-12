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
    func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    UserDefaults.standard.set(oauthToken?.accessToken, forKey: UserDefaults.Keys.kakaoAccessToken)
                    self.checkOriginUser()
                }
            }
        } else {
            // TODO: - 카카오톡이 깔려있지 않은 경우 Alert
        }
    }
    
    func checkOriginUser() {
        // TODO: - kakao accessToken으로 기존 유저인지 서버에 판단 요청
//        let path = ""
//        let resource = urlResource<Bool>(path: path)
//
//        apiSession.getRequest(with: resource)
//            .withUnretained(self)
//            .subscribe(onNext: { owner, result in
//                switch result {
//                case .failure(let error):
//                    owner.apiError.onNext(error)
//                case .success(let data):
//                    owner.output.isOriginUser.accept(data)
//                }
//            })
//            .disposed(by: bag)
        self.output.isOriginUser.accept(false)
    }
}
