//
//  ArrowBtn.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/11.
//

import UIKit
import SnapKit

class ArrowBtn: UIButton {
    let arrowImage = UIImageView(image: UIImage(named: "arrow_right")?.withTintColor(.gray300, renderingMode: .alwaysOriginal))
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, titleFont: UIFont = .body1) {
        super.init(frame: .zero)
        titleLabel?.font = titleFont
        setTitle(title, for: .normal)
        setTitleColor(.gray900, for: .normal)
        contentHorizontalAlignment = .left
        configureArrowImage()
    }
}

extension ArrowBtn {
    private func configureArrowImage() {
        addSubview(arrowImage)
        arrowImage.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
}
