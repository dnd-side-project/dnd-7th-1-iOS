//
//  UserInfoSettingVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/12.
//

import Foundation
import RxCocoa
import RxSwift

final class UserInfoSettingVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var isNextBtnActive = BehaviorRelay<Bool>(value: false)
        var isValidNickname = PublishRelay<Bool>()
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

extension UserInfoSettingVM {}

// MARK: - Input

extension UserInfoSettingVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension UserInfoSettingVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension UserInfoSettingVM {
    func getNicknameValidation(nickname: String) {
        let path = "auth/check/nickname?nickname=\(nickname)"
        let resource = urlResource<Bool>(path: path)
        
        AuthAPI.shared.checkNickname(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let isValid):
                    owner.output.isValidNickname.accept(isValid)
                    owner.output.isNextBtnActive.accept(isValid)
                }
            })
            .disposed(by: bag)
    }
    
    func postEditProfile(profile: EditProfileRequestModel) {
        let path = "user/info/profile/edit"
        let resource = urlResource<NicknameModel>(path: path)

        apiSession.postRequestWithImage(with: resource,
                                        param: profile.profileParam,
                                        image: profile.profileImage)
        .withUnretained(self)
        .subscribe(onNext: { owner, result in
            switch result {
            case .failure(let error):
                owner.apiError.onNext(error)
            case .success(let data):
                UserDefaults.standard.set(data.nickname, forKey: UserDefaults.Keys.nickname)
            }
        })
        .disposed(by: bag)
    }
}
