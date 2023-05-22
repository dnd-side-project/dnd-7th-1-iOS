//
//  APIErrorHandling.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol APIErrorHandling: UIViewController {
    var disposeBag: DisposeBag { get }
}

extension APIErrorHandling {
    /// APIError에 따른 알람창 연결
    func bindAPIErrorAlert(_ viewModel: any BaseViewModel) {
        viewModel.apiError
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                // loading 종료
                if let output = viewModel.output as? Lodable { output.endLoading() }
                
                // Error Alert
                let errorTitle = error.title
                let errorMessage = error.message
                let confirmEvent = self.errorAlertConfirmAction(error)
                self.popUpErrorAlert(targetVC: self,
                                     title: errorTitle,
                                     message: errorMessage,
                                     confirmEvent: confirmEvent)
            })
            .disposed(by: disposeBag)
    }
    
    /// Error Alert의 확인 버튼과 연결된 메서드
    func errorAlertConfirmAction(_ error: APIError) -> Selector {
        switch error {
        case .networkDisconnected:
            return #selector(confirmNetworkError)
        case .endOfOperation:
            // TODO: - 로그아웃 구현 후 수정
            return #selector(setLoginToRootVC)
        case .unknownError:
            return #selector(dismissAlert)
        case .error: break
        }
        
        // case .error(ErrorResponseModel)
        let errorCode = ErrorType(rawValue: error.code)
        switch errorCode {
        case .unknownUser:
            // TODO: - 로그아웃 구현 후 수정
            return #selector(setLoginToRootVC)
        default:
            return #selector(dismissAlert)
        }
    }
}
