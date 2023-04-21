//
//  TermsConditionsDetailButton.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/09.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

import SafariServices

class TermsConditionsDetailButton: UIButton {
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
        }
    
    private let checkImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "checkCircle")?.withTintColor(.gray300, renderingMode: .alwaysTemplate)
            $0.tintColor = .gray300
        }
    private let nameLabel = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray700
        }
    private let arrowImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "RightArrow")?.withTintColor(.gray700, renderingMode: .alwaysTemplate)
            $0.tintColor = .gray700
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Configure

extension TermsConditionsDetailButton {
    
    /// 이용약관 제목을 입력하는 함수
    func setTitle(title: String) {
        nameLabel.text = title
    }
    
    /// 버튼의 isEnable 상태에 따라 동의유무 상태 디자인 변경
    func isAgreeDetailButton(isAgree: Bool) {
        checkImageView.tintColor = isAgree ? .main : .gray300
    }
    
}

// MARK: - Layout

extension TermsConditionsDetailButton {
    
    private func configureLayout() {
        addSubviews([baseStackView])
        [checkImageView, nameLabel, arrowImageView].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(34.0)
        }
        baseStackView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        checkImageView.snp.makeConstraints {
            $0.width.height.equalTo(16.0)
        }
        arrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(12.0)
        }
    }
    
}
