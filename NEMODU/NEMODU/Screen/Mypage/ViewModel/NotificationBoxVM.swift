//
//  NotificationBoxVM.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/05/18.
//

import Foundation

import RxCocoa
import RxSwift

protocol NotificationBoxVMOuput: Lodable {
    var notificationList: PublishRelay<NotificationBoxResponseModel> { get }
}

final class NotificationBoxVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: NotificationBoxVMOuput {
        var loading = BehaviorRelay<Bool>(value: false)
        var notificationList = PublishRelay<NotificationBoxResponseModel>()
        var isSuccessMarkReadNotification = PublishRelay<Bool>()
        var isEmptyNotificationList = PublishRelay<Bool>()
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

extension NotificationBoxVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension NotificationBoxVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension NotificationBoxVM {
    func getUserNotificationList() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        let path = "noti?nickname=\(nickname)"
        let resource = urlResource<NotificationBoxResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                case .success(let data):
                    if(data.count == 0) {
                        owner.output.isEmptyNotificationList.accept(true)
                    } else {
                        owner.output.notificationList.accept(data)
                    }
                }
            })
            .disposed(by: bag)
    }
    
    func markUserNotificationRead(targetMessageId: String) {
        let path = "noti?messageId=\(targetMessageId)"
        let resource = urlResource<String>(path: path)
        
        apiSession.postRequest(with: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                    owner.output.isSuccessMarkReadNotification.accept(false)
                case .success(_):
                    owner.output.isSuccessMarkReadNotification.accept(true)
                }
            })
            .disposed(by: bag)
    }
    
    func emptyNotificationList(messageIdList: [String]) {
        let path = "noti/delete"
        let resource = urlResource<String>(path: path)

        apiSession.postRequest(with: resource, param: RemoveNotificationListRequestModel(notifications: messageIdList).removeNotificationList)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onError(error)
                    owner.output.isEmptyNotificationList.accept(false)
                case .success(_):
                    owner.output.isEmptyNotificationList.accept(true)
                }
            })
            .disposed(by: bag)
    }
}

