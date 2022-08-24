//
//  ProfileView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/21.
//

import UIKit
import SnapKit
import Then

class ProfileView: BaseView {
    let profileImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 56, height: 56)))
        .then {
            $0.image = UIImage(named: "defaultThumbnail")
            $0.layer.cornerRadius = 56 / 2
            $0.clipsToBounds = true
        }
    
    let textStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 4
        }
    
    let nickname = UILabel()
        .then {
            $0.font = .body2
            $0.textColor = .gray900
            $0.text = "-"
        }
    
    let profileMessage = UILabel()
        .then {
            $0.font = .body4
            $0.textColor = .gray400
            $0.text = "나의 소개글이 없습니다."
        }
    
    let arrow = UIImageView()
        .then {
            $0.image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray300
        }
    
    override func configureView() {
        super.configureView()
        addView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
}

// MARK: - Configure

extension ProfileView {
    private func addView() {
        addSubviews([profileImage,
                     textStackView,
                     arrow])
        [nickname, profileMessage].forEach {
            textStackView.addArrangedSubview($0)
        }
    }
}

// MARK: - Layout

extension ProfileView {
    private func configureLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.height.equalTo(56)
        }
        
        textStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
        }
        
        arrow.snp.makeConstraints {
            $0.leading.equalTo(textStackView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.width.height.equalTo(24)
        }
    }
}
