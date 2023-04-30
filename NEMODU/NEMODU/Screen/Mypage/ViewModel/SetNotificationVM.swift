//
//  SetNotificationVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/18.
//

import Foundation

import RxCocoa
import RxSwift

protocol SetNotificationVMOuput: Lodable {
    var userNotificationSettings: PublishRelay<SetNotificationResponseModel> { get }
}

final class SetNotificationVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: SetNotificationVMOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        var userNotificationSettings = PublishRelay<SetNotificationResponseModel>()
        var isSuccessUpdateNotificationSetting = PublishRelay<Bool>()
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

// MARK: - Input

extension SetNotificationVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension SetNotificationVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension SetNotificationVM {
    func getUserNotificationSettings() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "user/filter/notification?nickname=\(nickname)"
        let resource = urlResource<SetNotificationResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    owner.output.userNotificationSettings.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func updateNotificationSetting(notificationType: NotificationCategoryType) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        
        let path = "user/filter/notification"
        let resource = urlResource<Bool>(path: path)
        
        apiSession.postRequest(with: resource, param: UpdateNotificationSettingRequestModel(nickname: nickname, notification: notificationType.identifier).param)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                    owner.output.isSuccessUpdateNotificationSetting.accept(false)
                case .success(let data):
                    owner.output.isSuccessUpdateNotificationSetting.accept(data)
                }
            })
            .disposed(by: bag)
    }
}

