//
//  UIApplication+.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/05.
//

import UIKit

extension UIApplication {
    /// deprecated keyWindow를 대체
    var window: UIWindow? {
        UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.keyWindow
    }
    
    /// 최상위 viewController를 반환
    class func topViewController(base: UIViewController? = UIApplication.shared.window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController
            { return topViewController(base: selected) }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
