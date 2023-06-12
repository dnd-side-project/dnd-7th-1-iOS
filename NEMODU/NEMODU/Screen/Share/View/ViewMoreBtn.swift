//
//  ViewMoreBtn.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/24.
//

import UIKit
import SnapKit

class ViewMoreBtn: UIButton {
    var config = UIButton.Configuration.plain()
    
    private let separatorView = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var titleAttributedString = AttributedString.init("더보기")
        titleAttributedString.font = .body4
        titleAttributedString.foregroundColor = .gray600
        config.attributedTitle = titleAttributedString
        
        config.image = UIImage(named: "arrow_right")?.withTintColor(.gray600)
        config.imagePlacement = .trailing
        
        addSubview(separatorView)
        separatorView.backgroundColor = .gray100
        separatorView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        configuration = config
    }
}
