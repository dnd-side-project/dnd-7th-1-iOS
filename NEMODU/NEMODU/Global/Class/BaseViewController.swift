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
    
    /// 현재 화면의 rootViewController까지 dismiss하는 메서드
    @objc func dismissToRootVC() {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - APIErrorHandling

extension BaseViewController: APIErrorHandling {}
