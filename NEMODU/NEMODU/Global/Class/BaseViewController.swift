//
//  BaseViewController.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Properties
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutView()
        bindRx()
        hideKeyboard()
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func layoutView() {}
    
    func bindRx() {
        bindDependency()
        bindInput()
        bindOutput()
        bindLoading()
    }
    
    func bindDependency() {}
    
    func bindInput() {}
    
    func bindOutput() {}
    
    func bindLoading() {}
    
}

// MARK: - Custom Methods

extension BaseViewController {
    /// 메인화면을 rootViewControllerf로 변경하는 메서드
    func setTBCtoRootVC() {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        ad.window?.rootViewController = NEMODUTBC()
    }
    
    /// 제스쳐로 뒤로가기 인터랙션 Enabled 상태를 지정하는 메서드
    func setInteractivePopGesture(_ isEnabled: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabled
    }
    
    // MARK: - objc
    /// 로그인 화면을 rootViewControllerf로 변경하는 메서드
    @objc func setLoginToRootVC() {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        ad.window?.rootViewController = LoginNC()
    }
}

// MARK: - API Error Handling

extension BaseViewController {
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
