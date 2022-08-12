//
//  UIStackView+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/12.
//

import UIKit

extension UIStackView {
    /// stackView에 세로 구분선을 추가하는 함수
    func addVerticalSeparators(color : UIColor, width: CGFloat, multiplier: CGFloat = 1) {
        var i = self.arrangedSubviews.count - 1
        while i > 0 {
            let separator = createSeparator(color: color, width: width)
            insertArrangedSubview(separator, at: i)
            separator.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: multiplier).isActive = true
            i -= 1
        }
    }

    /// vertical separator을 반환하는 함수
    private func createSeparator(color: UIColor, width: CGFloat) -> UIView {
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: width).isActive = true
        separator.backgroundColor = color
        return separator
    }
}
