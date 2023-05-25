//
//  PopupToastViewDelegate.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/24.
//

import Foundation

protocol PopupToastViewDelegate: AnyObject {
    func popupToastView(_ toastType: ToastType)
}
