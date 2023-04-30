//
//  ToastView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/25.
//

import UIKit
import SnapKit
import Then

class ToastView: BaseView {
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 8
        }
    
    private let warningImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "warning")
        }
    
    private let toastMessage = UILabel()
        .then {
            $0.font = .PretendardMedium(size: 14)
            $0.textColor = .white
            $0.textAlignment = .center
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

extension ToastView {
    private func configureContentView() {
        backgroundColor = .gray900
        layer.cornerRadius = 5
        
        addSubview(baseStackView)
    }
    
    func configureToastView(of toastType: ToastType) {
        toastMessage.text = toastType.toastMessage
        
        switch toastType {
        case .friendProfileError, .networkError:
            [warningImageView, toastMessage].forEach {
                baseStackView.addArrangedSubview($0)
            }
            setImageSize()
        case .friendAdded, .friendDeleted, .nicknameChanged:
            baseStackView.addArrangedSubview(toastMessage)
        }
    }
}

// MARK: - Layout

extension ToastView {
    private func configureLayout() {
        baseStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setImageSize() {
        warningImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
        }
    }
}
