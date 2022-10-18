//
//  ViewMoreTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/17.
//

import UIKit
import Then
import SnapKit

class ViewMoreTVC: BaseTableViewCell {
    private let separatorView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }

    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
        }
    
    private let moreLabel = UILabel()
        .then {
            $0.text = "더보기"
            $0.font = .body4
            $0.textColor = .gray600
        }
    
    private let arrowImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "arrow_right")?.withTintColor(.gray600)
        }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
}

// MARK: - Configure

extension ViewMoreTVC {
    private func configureContentView() {
        addSubviews([separatorView,
                     baseStackView])
        [moreLabel, arrowImageView].forEach {
            baseStackView.addArrangedSubview($0)
        }
    }
}

// MARK: - Layout

extension ViewMoreTVC {
    private func configureLayout() {
        separatorView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        baseStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
}
