//
//  KakaoInterceptor.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/25.
//

import Alamofire
import KakaoSDKAuth

class KakaoInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let kakaoAccessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.kakaoAccessToken) else { return }
        
        var urlRequest = urlRequest
        urlRequest.headers.add(name: "Kakao-Access-Token", value: kakaoAccessToken)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        AuthApi.shared.refreshToken { oauthToken, error in
            if let error = error {
                completion(.doNotRetryWithError(error))
            } else {
                UserDefaults.standard.set(oauthToken?.accessToken, forKey: UserDefaults.Keys.kakaoAccessToken)
                UserDefaults.standard.set(oauthToken?.refreshToken, forKey: UserDefaults.Keys.kakaoRefreshToken)
                completion(.retry)
            }
        }
    }
}
