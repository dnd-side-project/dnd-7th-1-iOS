//
//  AuthAPI.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/19.
//

import Alamofire
import RxSwift

struct AuthAPI {
    /// 간편하게 API를 호출할 수 있도록 제공되는 공용 싱글톤 객체
    static let shared = AuthAPI()
}

// MARK: - API

extension AuthAPI {
    /// 토큰 갱신 시 accessToken과 refreshToken을 저장하는 메서드
    func setUserDefaultsToken(headers: HTTPHeaders?) {
        guard let authToken = headers?.value(for: "Authorization"),
              let refreshToken = headers?.value(for: "Refresh-Token") else { return }
        UserDefaults.standard.set(authToken, forKey: UserDefaults.Keys.accessToken)
        UserDefaults.standard.set(refreshToken, forKey: UserDefaults.Keys.refreshToken)
    }
    
    /// [POST] 헤더에 kakaoAccessToken을 붙여 로그인을 요청하는 메서드
    func kakaoLoginRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            guard let kakaoAccessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoAccessToken) else { fatalError() }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Kakao-Access-Token": kakaoAccessToken
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  parameters: param,
                                  encoding: JSONEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                        
                    case .success(let data):
                        observer.onNext(.success(data))
                        setUserDefaultsToken(headers: response.response?.headers)
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// [GET] 헤더에 kakaoAccessToken을 붙여 기존 유저인지 확인을 요청하는 메서드
    func checkOriginUser<T>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> where T : Decodable {
        
        Observable<Result<T, APIError>>.create { observer in
            guard let kakaoAccessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoAccessToken) else { fatalError() }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Access-Token": kakaoAccessToken
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  encoding: URLEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                        
                    case .success(let data):
                        observer.onNext(.success(data))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// [GET] refreshToken으로 accessToken, refreshToken 재발급
    func renewalToken() -> Observable<Result<Bool, APIError>> {
        
        Observable<Result<Bool, APIError>>.create { observer in
            guard let refreshToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) else { fatalError() }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Refresh-Token": refreshToken
            ]
            
            let path = "auth/refreshToken"
            let urlResource = urlResource<Bool>(path: path)
            
            let task = AF.request(urlResource.resultURL,
                                  encoding: URLEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: Bool.self) { response in
                    switch response.result {
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                        
                    case .success(let data):
                        setUserDefaultsToken(headers: response.response?.headers)
                        observer.onNext(.success(data))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// [GET] 닉네임 중복확인을 진행하는 메서드
    func checkNickname<T>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> where T : Decodable {
        
        Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  encoding: URLEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                        
                    case .success(let data):
                        observer.onNext(.success(data))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
