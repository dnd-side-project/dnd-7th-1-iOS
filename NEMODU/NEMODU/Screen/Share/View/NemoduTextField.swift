//
//  NemoduTextField.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/14.
//

import UIKit
import SnapKit
import Then

class NemoduTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLeftPadding()
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = .gray50
        font = .body3
        textColor = .gray900
        attributedPlaceholder = NSAttributedString(string: "tmpPlaceholder",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray500])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
