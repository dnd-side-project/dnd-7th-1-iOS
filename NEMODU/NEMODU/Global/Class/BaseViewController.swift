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
    
    /// 메인화면을 rootViewControllerf로 변경하는 메서드
    func setTBCtoRootVC() {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        ad.window?.rootViewController = NEMODUTBC()
    }
    
    /// 로그인 화면을 rootViewControllerf로 변경하는 메서드
    func setLoginToRootVC() {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        ad.window?.rootViewController = LoginNC()
    }
}
