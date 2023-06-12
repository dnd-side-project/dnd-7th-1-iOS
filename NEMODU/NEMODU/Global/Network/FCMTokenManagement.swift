//
//  FCMTokenManagement.swift
//  NEMODU
//
//  Created by Kennadi on 2023/06/12.
//

import Alamofire
import RxSwift

struct FCMTokenManagement {
    
    // MARK: - Variables and Properties
    
    static let shared = FCMTokenManagement()
    
    // MARK: - FCM Token 갱신
    
    /// [POST] FCM 토큰을 서버에 최신화하기 위해 서버에 등록된 사용자의 fcmToken 변경을 요청 하는 함수
    func updateFCMToken(targetFCMToken: String) -> Observable<Result<String, APIError>> {
        Observable<Result<String, APIError>>.create { observer in
            if !NetworkMonitor.shared.isConnected {
                observer.onNext(.failure(.networkDisconnected))
                return Disposables.create()
            }
            
            guard let token = UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken) else { return Disposables.create() }
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization" : token
            ]
            
            let path = "auth/fcm/token"
            let resource = urlResource<String>(path: path)

            guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return Disposables.create() }
            let param = UpdateFCMTokenRequestModel(deviceType: getDeviceType(),
                                                   fcmToken: targetFCMToken,
                                                   nickname: nickname).param

            let task = AF.request(resource.resultURL,
                                  method: .post,
                                  parameters: param,
                                  encoding: JSONEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: String.self) { response in
                    switch response.result {
                    case .failure(let error):
                        dump(error)
                        guard let error = response.data else { return }
                        observer.onNext(resource.judgeError(data: error))
                        
                    case .success(let data):
                        // 디바이스에 업데이트에 성공한 fcmToken을 로컬로 저장
                        UserDefaults.standard.set(targetFCMToken, forKey: UserDefaults.Keys.fcmToken)
                        observer.onNext(.success(data))
                    }
                }

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// (FCM Token 관리를 위한) 현재 디바이스 정보 값(PHONE or Pad) 반환
    func getDeviceType() -> String {
        UIDevice.current.model.contains("iPhone") ? "PHONE" : "PAD"
    }
    
}
