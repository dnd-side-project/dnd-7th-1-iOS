//
//  UIScrollView+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/11.
//

import UIKit

extension UIScrollView {
    var bottomOffset: Double {
        contentSize.height - bounds.size.height + contentInset.bottom
    }
    
    /// scrollView를 최상단으로 스크롤하는 함수
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: 0)
        self.setContentOffset(topOffset, animated: true)
    }
    
    /// scrollView를 최하단으로 스크롤하는 함수
    func scrollToBottom(animated: Bool) {
      if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: bottomOffset)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    
    /// scrollView를 지정 offset으로 스크롤하는 함수 - offset y
    func scrollToVerticalOffset(offset: Double, animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: offset)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    
    /// scrollView를 지정 offset으로 스크롤하는 함수 - offset x
    func scrollToHorizontalOffset(offset: Double, animated: Bool = true) {
        let bottomOffset = CGPoint(x: offset, y: 0)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
