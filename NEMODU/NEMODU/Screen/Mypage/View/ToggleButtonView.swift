//
//  ToggleButtonView.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/04/06.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ToggleButtonView: BaseView {
    private var baseStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 8
        }
    
    private var statusTitle = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    private var statusLabel = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray500
            $0.setLineBreakMode()
        }
    
    var toggleBtn = UISwitch()
        .then {
            $0.onTintColor = .main
        }
    
    private let bag = DisposeBag()
    
    override func configureView() {
        super.configureView()
        addViews()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
}

// MARK: - Configure

extension ToggleButtonView {
    private func addViews() {
        addSubviews([baseStackView,
                     toggleBtn])
        [statusTitle, statusLabel].forEach {
            baseStackView.addArrangedSubview($0)
        }
    }
    
    /// view의 타이틀과 폰트를 지정하는 메서드
    func setTitle(_ title: String,
                  _ font: UIFont = .body3) {
        statusTitle.text = title
        statusTitle.font = font
    }
    
    /// view의 메시지와 폰트를 지정하는 메서드
    func setMessage(_ text: String,
                    _ font: UIFont = .caption1) {
        statusLabel.text = text
        statusLabel.font = font
    }
}

// MARK: - Layout

extension ToggleButtonView {
    private func configureLayout() {
        baseStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        toggleBtn.snp.makeConstraints {
            $0.leading.equalTo(baseStackView.snp.trailing).offset(8)
            $0.centerY.trailing.equalToSuperview()
        }
    }
}
