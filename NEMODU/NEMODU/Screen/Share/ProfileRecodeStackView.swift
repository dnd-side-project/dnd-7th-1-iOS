//
//  ProfileRecodeStackView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/14.
//

import UIKit
import SnapKit
import Then

class ProfileRecodeStackView: BaseView {
    private let stackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 8
        }
    
    var firstView = ProfileRecodeView()
    var secondView = ProfileRecodeView()
    var thirdView = ProfileRecodeView()
    
    override func configureView() {
        super.configureView()
        configureRecodeStackView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
}

// MARK: - Configure

extension ProfileRecodeStackView {
    private func configureRecodeStackView() {
        addSubview(stackView)
        [firstView, secondView, thirdView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    /// stackView 세 영역의 값을 지정하는 함수입니다.
    func setRecodeData(value1: Int, value2: Int, value3: Int) {
        firstView.recodeValue.text = String(value1)
        secondView.recodeValue.text = String(value2)
        thirdView.recodeValue.text = String(value3)
    }
}

// MARK: - Layout

extension ProfileRecodeStackView {
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
