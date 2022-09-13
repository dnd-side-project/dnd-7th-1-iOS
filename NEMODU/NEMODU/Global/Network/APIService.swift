//
//  APIService.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import Alamofire
import RxSwift

protocol APIService {
    func kakaoLoginRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>>
    
    func getRequest<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>>
    
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters?) -> Observable<Result<T, APIError>>
    
    func postRequestWithImage<T: Decodable>(with urlResource: urlResource<T>, param: Parameters, image: UIImage, method: HTTPMethod) -> Observable<Result<T, APIError>>
    
    func checkOriginUser<T>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>> where T : Decodable
}

