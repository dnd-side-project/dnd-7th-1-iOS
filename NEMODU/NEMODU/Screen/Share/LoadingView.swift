//
//  LoadingView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import SnapKit
import Then
import UIKit

class LoadingView: BaseView {
    private var indicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                                  y: 0, width: 50,
                                                                  height: 50))

    override func configureView() {
        backgroundColor = .black.withAlphaComponent(0.3)
        addSubview(indicator)
    }
    
    override func layoutView() {
        indicator.center = center
        indicator.startAnimating()
    }
}
