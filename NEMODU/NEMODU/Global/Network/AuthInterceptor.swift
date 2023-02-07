//
//  AuthInterceptor.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/15.
//

import Alamofire
import RxSwift

class AuthInterceptor: RequestInterceptor {
    let bag = DisposeBag()
    
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
        
        // accessToken이 401 만료되었을 경우 토큰 갱신 요청 후 retry
        AuthAPI.shared.renewalToken()
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                    DispatchQueue.main.async {
                        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
                        ad.window?.rootViewController = LoginNC()
                        print("토큰 모두 만료 로그인으로 이동")
                    }
                case .success(_):
                    completion(.retry)
                }
            })
            .disposed(by: bag)
    }
}
