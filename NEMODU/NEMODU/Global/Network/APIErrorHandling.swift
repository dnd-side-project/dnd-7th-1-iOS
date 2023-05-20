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
        // TODO: - 테플용 error code 노출
        viewModel.apiError
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                // loading 종료
                if let output = viewModel.output as? Lodable { output.endLoading() }
                
                // Error Alert
                let errorTitle = error.title ?? "서비스에 오류가 발생했습니다 😢"
                let errorCode = "Error Code: \(error.code ?? "unknown error")"
                let confirmEvent = self.errorAlertConfirmAction(error.code)
                self.popUpErrorAlert(targetVC: self,
                                     title: errorTitle,
                                     message: errorCode,
                                     confirmEvent: confirmEvent)
            })
            .disposed(by: disposeBag)
    }
    
    /// Error Alert의 확인 버튼과 연결된 메서드
    func errorAlertConfirmAction(_ errorCode: String?) -> Selector {
        let errorCode = errorCode != nil ? ErrorType(rawValue: errorCode!) : .unknownError
        switch errorCode {
        case .unknownUser:
            return #selector(setLoginToRootVC)
        default:
            return #selector(dismissAlert)
        }
    }
}
