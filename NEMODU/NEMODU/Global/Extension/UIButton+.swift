//
//  UIButton+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit
extension UIButton {
    /// UIButton의 State에 따라 backgroundColor를 변경하는 함수
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(minimumSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: minimumSize))
        }
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.clipsToBounds = true
        self.setBackgroundImage(colorImage, for: state)
    }
    
    /// selected 상태에 따라 버튼 이미지를 바꿔주는 함수
    func toggleButtonImage(defaultImage: UIImage, selectedImage: UIImage) {
        self.setImage(defaultImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
    }
    
    /// 버튼 이미지를 상단에, 버튼 타이틀을 하단에 배치해주는 함수
    func centerVertically(spacing: CGFloat = 6.0) {
        guard
            let image = self.imageView?.image,
            let titleLabel = self.titleLabel,
            let titleText = titleLabel.text else {
            return
        }

        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])

        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}
