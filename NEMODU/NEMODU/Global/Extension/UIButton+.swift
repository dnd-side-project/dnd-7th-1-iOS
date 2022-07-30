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
}
