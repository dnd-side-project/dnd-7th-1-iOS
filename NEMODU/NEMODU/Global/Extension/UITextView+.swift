//
//  UITextView+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit

extension UITextView {
    /// setTextViewToViewer - textView를 드래그 불가 뷰어용으로 설정
    func setTextViewToViewer() {
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
    
    /// setPadding - textView 기본 padding값 설정
    func setPadding() {
        self.textContainerInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
    }
}
