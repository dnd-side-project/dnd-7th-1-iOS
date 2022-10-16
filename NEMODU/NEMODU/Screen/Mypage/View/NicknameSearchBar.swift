//
//  NicknameSearchBar.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import SnapKit

class NicknameSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSearchBar()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure & Layout

extension NicknameSearchBar{
    private func configureSearchBar() {
        backgroundImage = UIImage()
        searchBarStyle = .prominent
        tintColor = .main
        searchTextField.font = .body3
        searchTextField.textColor = .gray900
        searchTextField.placeholder = "닉네임으로 검색"
        searchTextField.backgroundColor = .gray50
    }
    
    private func configureLayout() {
        searchTextField.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
}
