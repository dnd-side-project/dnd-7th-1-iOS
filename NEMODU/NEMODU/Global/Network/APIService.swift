//
//  APIService.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import Alamofire
import RxSwift

protocol APIService {
    func getRequest<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>>
    
    func getRequestWithoutHeader<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>>
    
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters?) -> Observable<Result<T, APIError>>
    
    func deleteRequest<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>>
}

