//
//  KakaoAPI.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/23.
//

import Alamofire
import RxSwift
import RxCocoa
import KakaoSDKUser

struct KakaoAPI {
    static let shared = KakaoAPI()
}

extension KakaoAPI {
    func getKakaoFriendList<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> {
        
        Observable<Result<T, APIError>>.create { observer in
            if !NetworkMonitor.shared.isConnected {
                observer.onNext(.failure(.networkDisconnected))
                return Disposables.create()
            }
            // TODO: - 토큰 만료 처리 추가
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Kakao-Access-Token": UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoAccessToken) ?? ""
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  encoding: URLEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .failure(let error):
                        dump(error)
                        guard let error = response.data else {
                            observer.onNext(.failure(.endOfOperation(response.response?.statusCode ?? -1)))
                            return
                        }
                        observer.onNext(urlResource.judgeError(data: error))
                        
                    case .success(let data):
                        observer.onNext(.success(data))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func postKakaoInviteRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters?) -> Observable<Result<T, APIError>> {
        
        Observable<Result<T, APIError>>.create { observer in
            if !NetworkMonitor.shared.isConnected {
                observer.onNext(.failure(.networkDisconnected))
                return Disposables.create()
            }
            // TODO: - 토큰 만료 처리 추가
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Kakao-Access-Token": UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoAccessToken) ?? ""
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  parameters: param,
                                  encoding: URLEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .failure(let error):
                        dump(error)
                        guard let error = response.data else {
                            observer.onNext(.failure(.endOfOperation(response.response?.statusCode ?? -1)))
                            return
                        }
                        observer.onNext(urlResource.judgeError(data: error))
                        
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
