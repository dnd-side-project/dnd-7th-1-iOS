//
//  UIViewController+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit
import SnapKit

extension UIViewController {
    
    /// className을 String으로 반환하는 프로퍼티
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    /// 화면 터치 시 키보드 내리는 함수
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// 화면 터치 시 키보드 내리는 함수
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: false)
    }
    
    /// 설정 앱 열기
    @objc func openSystem() {
        dismissAlert()
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    /// 알람창을 닫고 viewController를 pop시키는 메서드
    @objc func dismissAlertAndPopVC() {
        dismissAlert()
        popVC()
    }
    
    /// 로그인 화면을 rootViewControllerf로 변경하는 메서드
    @objc func setLoginToRootVC() {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        ad.window?.rootViewController = LoginNC()
    }
    
    /// 네트워크 연결 에러 알람창 확인 버튼 메서드
    @objc func confirmNetworkError() {
        if NetworkMonitor.shared.isConnected {
            dismissAlert()
        }
    }
    
    /// 로그아웃, 회원 탈퇴 시 저장된 회원 정보를 지우고 로그인 화면으로 이동하는 메서드
    @objc func removeUserData() {
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.loginType)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.accessToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.refreshToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.appleToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.kakaoAccessToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.kakaoRefreshToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.kakaoUserID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.nickname)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.email)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.pictureName)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.picturePath)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.fcmToken)
    }
    
    /// 기기 스크린 hight에 맞춰 비율을 계산해 height를 리턴하는 함수
    func calculateHeightbyScreenHeight(originalHeight: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return originalHeight * (screenHeight / 812)
    }
    
    /// 확인 버튼 Alert 메서드
    func makeAlert(title : String, message : String? = nil,
                   okTitle: String = "확인", okAction : ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    /// topViewController에 로딩을 보여주는 메서드
    func loading(loading: Bool) {
        guard let topViewController = UIApplication.topViewController() else { return }
        
        if loading {
            let loadingView = LoadingView(frame: topViewController.view.frame)
            topViewController.view.addSubview(loadingView)
            return
        }
        
        guard let loadingView = topViewController.view.subviews.compactMap({ $0 as? LoadingView }).first else { return }
        loadingView.removeFromSuperview()
    }
    
    /// 알람창을 띄우는 메서드
    func popUpAlert(alertType: AlertType,
                    targetVC: UIViewController,
                    highlightBtnAction: Selector,
                    normalBtnAction: Selector?) {
        let alertVC = AlertVC()
        alertVC.configureAlert(of: alertType,
                               targetVC: targetVC,
                               highlightBtnAction: highlightBtnAction,
                               normalBtnAction: normalBtnAction)
        alertVC.modalPresentationStyle = .overFullScreen
        targetVC.present(alertVC, animated: false, completion: nil)
    }
    
    /// 에러 알림창을 띄우는 메서드.
    /// local Error일 경우에만 직접 호출.
    /// 네트워크 에러의 경우 bindAPIErrorAlert 사용해주세요.
    func popUpErrorAlert(targetVC: UIViewController,
                         title: String,
                         message: String?,
                         confirmEvent: Selector) {
        let alertVC = AlertVC()
        alertVC.configureErrorAlert(targetVC: targetVC,
                                    title: title,
                                    message: message,
                                    confirmEvent: confirmEvent)
        alertVC.modalPresentationStyle = .overFullScreen
        targetVC.present(alertVC, animated: false, completion: nil)
    }
    
    /// 시스템 에러 Alert 메서드
    func systemErrorAlert(_ message: String?) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm",
                                   style: .default)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    /// ToastType에 맞는 ToastView를 띄워주는 메서드
    func popupToast(toastType: ToastType) {
        let toastView = ToastView()
        view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-14)
            $0.height.equalTo(48)
        }
        
        toastView.configureToastView(of: toastType)
        
        UIView.animate(withDuration: 0.2, delay: 1, options: .curveEaseOut, animations: {
            toastView.alpha = 0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
    
    /// 프로필 사진 상세보기 뷰를 띄워주는 함수
    func showProfileImage(with image: UIImage) {
        let profileImageVC = ProfileImageVC()
        profileImageVC.profileImage.image = image
        profileImageVC.modalPresentationStyle = .overFullScreen
        present(profileImageVC, animated: true)
    }
}
