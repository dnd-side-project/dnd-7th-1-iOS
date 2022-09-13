//
//  APISession.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import Alamofire
import RxSwift
import Foundation

struct APISession: APIService {
    
    func setUserDefaultsToken(headers: HTTPHeaders?) {
        guard let authToken = headers?.value(for: "Authorization"),
              let refreshToken = headers?.value(for: "Refresh-Token") else { return }
        UserDefaults.standard.set(authToken, forKey: UserDefaults.Keys.accessToken)
        UserDefaults.standard.set(refreshToken, forKey: UserDefaults.Keys.refreshToken)
    }
    
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
    
    func getRequest<T>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> where T : Decodable {
        
        Observable<Result<T, APIError>>.create { observer in
            guard let accessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken) else { fatalError() }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": accessToken
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
    
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters?) -> Observable<Result<T, APIError>> {
        
        Observable<Result<T, APIError>>.create { observer in
            guard let accessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken) else { fatalError() }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": accessToken
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
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func postRequestWithImage<T: Decodable>(with urlResource: urlResource<T>, param: Parameters, image: UIImage, method: HTTPMethod) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            guard let accessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken) else { fatalError() }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": accessToken
            ]
            
            let task = AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                }
                if let imageData = image.jpegData(compressionQuality: 1) {
                    multipart.append(imageData, withName: "files", fileName: "image.png", mimeType: "image/png")
                }
            }, to: urlResource.resultURL, method: method, headers: headers)
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
