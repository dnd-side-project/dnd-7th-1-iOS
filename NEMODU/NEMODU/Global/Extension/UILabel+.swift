//
//  UILabel+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit

extension UILabel {
    @IBInspectable
    
    /// 자간 조정
    var letterSpacing: CGFloat {
        set {
            let attributedString: NSMutableAttributedString
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: self.text ?? "")
                self.attributedText = attributedString
            }
            
            attributedString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
    
    /// 여러 줄 보기
    func setLineBreakMode() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        lineBreakMode = .byCharWrapping
    }
    
    /// 세자리수마다 콤마를 추가하는 함수
    func insertComma() {
        guard let number = text else { return }
        text = number.insertComma
    }
}
