//
//  TabCVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import SnapKit
import Then
import UIKit

class TabCVC: BaseCollectionViewCell {
    var tabLabel = UILabel()
        .then {
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.font = .headline1
        }
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(tabLabel)
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override var isSelected: Bool {
        didSet {
            tabLabel.textColor = isSelected ? .gray900 : .gray400
        }
    }
}

// MARK: - Configure

extension TabCVC {
    func configureTabTitle(with menu: String) {
        tabLabel.text = menu
    }
}

// MARK: - Layout

extension TabCVC {
    private func configureLayout() {
        tabLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
