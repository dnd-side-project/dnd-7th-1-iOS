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
    
    /// [GET]
    func getRequest<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> where T : Decodable {
        
        Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  encoding: URLEncoding.default,
                                  headers: headers,
                                  interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    dump(response)
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
    
    /// [POST]
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters?) -> Observable<Result<T, APIError>> {
        
        Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  parameters: param,
                                  encoding: JSONEncoding.default,
                                  headers: headers,
                                  interceptor: AuthInterceptor())
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
    
    /// [POST] - multipartForm
    func postRequestWithImage<T: Decodable>(with urlResource: urlResource<T>, param: Parameters, image: UIImage, method: HTTPMethod) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let task = AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                }
                if let imageData = image.jpegData(compressionQuality: 1) {
                    multipart.append(imageData, withName: "picture", fileName: "image.png", mimeType: "image/png")
                }
            }, to: urlResource.resultURL,
                                 method: .post,
                                 headers: headers,
                                 interceptor: AuthInterceptor())
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
