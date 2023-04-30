//
//  LoadingView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import SnapKit
import Then
import UIKit
import Lottie

class LoadingView: BaseView {
    private var indicator = AnimationView(name: "loading")
        .then {
            $0.play()
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFill
        }

    override func configureView() {
        backgroundColor = .black.withAlphaComponent(0.3)
        addSubview(indicator)
    }
    
    override func layoutView() {
        indicator.snp.makeConstraints {
            $0.width.height.equalTo(150)
            $0.center.equalToSuperview()
        }
    }
}
