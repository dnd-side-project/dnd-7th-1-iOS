//
//  AuthInterceptor.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/15.
//

import Alamofire

class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken) else { return }
        
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(accessToken))
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            // 401 외의 오류 코드
            completion(.doNotRetryWithError(error))
            return
        }
        // accessToken이 401 만료되었을 경우 refreshToken으로 갱신 요청
        // refreshToken도 만료 시 로그인 화면으로 이동 throw
//        DispatchQueue.main.async {
//            guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
//            ad.window?.rootViewController = LoginNC()
//        }
    }
}
