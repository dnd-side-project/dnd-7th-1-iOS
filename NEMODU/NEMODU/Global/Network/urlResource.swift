//
//  urlResource.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import Foundation

struct urlResource<T: Decodable> {
    let baseURL = URL(string: "http://43.201.133.215:8080/")
    let path: String
    var resultURL: URL {
        return path.contains("http")
        ? URL(string: path)!
        : baseURL.flatMap { URL(string: $0.absoluteString + path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) }!
    }
    
    func judgeError(data: Data) -> Result<T, APIError> {
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(ErrorResponseModel.self, from: data) else {
            return .failure(.badGateway)
        }
        
        return .failure(.error(decodeData))
    }
}
