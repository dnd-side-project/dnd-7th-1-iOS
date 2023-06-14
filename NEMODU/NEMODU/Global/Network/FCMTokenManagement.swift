//
//  FCMTokenManagement.swift
//  NEMODU
//
//  Created by Kennadi on 2023/06/12.
//

import Alamofire
import RxSwift

import Firebase

struct FCMTokenManagement {
    
    // MARK: - Variables and Properties
    
    static let shared = FCMTokenManagement()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    private init() { }
    
    // MARK: - FCM Token 갱신
    
    /// FCM 토큰의 nil 값을 검사하고 유효한 토큰을 네모두 서버에 등록하는 함수
    func updateFCMToken(targetFCMToken: String?) {
        if let targetFCMToken = targetFCMToken {
            registerUserFCMToken(targetFCMToken: targetFCMToken)
        } else {
            // 현재 등록 fcmToken 재조회
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("FCM 토큰을 불러올 수 없습니다: \(error)")
                } else if let token = token {
                    print("FCM 토큰 조회 성공: \(token)")
                    registerUserFCMToken(targetFCMToken: token)
                }
            }
        }
    }
    
    /// 네모두 서버에 사용자의 FCM 토큰을 등록하는 함수
    func registerUserFCMToken(targetFCMToken: String) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)
        else { fatalError() } // TODO: - nickname fatalError 처리
        
        let path = "auth/fcm/token"
        let resource = urlResource<String>(path: path)
        let param = UpdateFCMTokenRequestModel(deviceType: getDeviceType(),
                                               fcmToken: targetFCMToken,
                                               nickname: nickname).param
        
        apiSession.postRequest(with: resource, param: param)
            .subscribe(onNext: { result in
                switch result {
                case .failure(let error):
                    apiError.onError(error)
                case .success(let data):
                    print("FCM 토큰 갱신 성공: ", data)
                    // 업데이트에 성공한 FCM 토큰을 디바이스에 로컬로 저장
                    UserDefaults.standard.set(targetFCMToken, forKey: UserDefaults.Keys.fcmToken)
                }
            })
            .disposed(by: bag)
    }
    
    /// (FCM Token 관리를 위한) 현재 디바이스 정보 값(PHONE or Pad) 반환
    func getDeviceType() -> String {
        UIDevice.current.model.contains("iPhone") ? "PHONE" : "PAD"
    }
    
}
