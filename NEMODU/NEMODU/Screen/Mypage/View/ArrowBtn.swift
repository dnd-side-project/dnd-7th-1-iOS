//
//  ArrowBtn.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/11.
//

import UIKit
import SnapKit

class ArrowBtn: UIButton {
    var config = UIButton.Configuration.plain()
    let arrowImage = UIImageView(image: UIImage(named: "arrow_right")?.withTintColor(.gray300, renderingMode: .alwaysOriginal))
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, titleFont: UIFont = .body1, padding: CGFloat = 16) {
        super.init(frame: .zero)
        config.baseForegroundColor = .gray900
        config.contentInsets = .init(top: 0,
                                     leading: padding,
                                     bottom: 0,
                                     trailing: padding)
        var titleAttributedString = AttributedString.init(title)
        titleAttributedString.font = titleFont
        config.attributedTitle = titleAttributedString
        
        self.configuration = config
        contentHorizontalAlignment = .left
        configureArrowImage(padding: padding)
    }
}

extension ArrowBtn {
    private func configureArrowImage(padding: CGFloat) {
        addSubview(arrowImage)
        arrowImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(padding * -1)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
}
