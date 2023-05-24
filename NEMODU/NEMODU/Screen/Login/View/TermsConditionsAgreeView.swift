//
//  TermsConditionsAgreeView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/09.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

class TermsConditionsAgreeView: BaseView {
    
    // MARK: - UI components
    
    let checkStatusButton = UIButton()
    private let checkImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "checkCircle")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray300
        }
    
    let seeDetailTermsConditionsButton = UIButton()
    private let seeDetailStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
        }
    private let nameLabel = UILabel()
        .then {
            $0.font = .body3
            $0.textColor = .gray700
        }
    private let arrowImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "arrow_right")?.withTintColor(.gray300, renderingMode: .alwaysTemplate)
            $0.tintColor = .gray300
        }
    
    // MARK: - Variables and Properties
    
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
}

// MARK: - Configure

extension TermsConditionsAgreeView {
    
    /// 이용약관 제목을 입력하는 함수
    func setTitle(title: String) {
        nameLabel.text = title
    }
    
    /// 버튼의 isSelected 상태에 따라 동의유무 상태 디자인 변경
    func isAgreeDetailTermsConditions(isAgree: Bool) {
        checkStatusButton.isSelected = isAgree
        checkImageView.tintColor = isAgree ? .main : .gray300
    }
    
}

// MARK: - Layout

extension TermsConditionsAgreeView {
    
    private func configureLayout() {
        addSubviews([checkStatusButton,
                     seeDetailTermsConditionsButton])
        checkStatusButton.addSubviews([checkImageView])
        seeDetailTermsConditionsButton.addSubviews([seeDetailStackView])
        [nameLabel, arrowImageView].forEach {
            seeDetailStackView.addArrangedSubview($0)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(40.0)
        }
        
        checkStatusButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        checkImageView.snp.makeConstraints {
            $0.width.height.equalTo(16.0)
            $0.center.equalTo(checkStatusButton)
        }
        
        seeDetailTermsConditionsButton.snp.makeConstraints {
            $0.height.equalTo(checkStatusButton.snp.height)
            $0.centerY.right.equalToSuperview()
            $0.left.equalTo(checkStatusButton.snp.right)
            $0.right.equalToSuperview()
        }
        seeDetailStackView.snp.makeConstraints {
            $0.edges.equalTo(seeDetailTermsConditionsButton)
        }
        arrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
        }
    }
    
}
