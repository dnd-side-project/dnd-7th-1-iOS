//
//  MenuBarCVCell.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import Then
import SnapKit

class MenuBarCVCell: UICollectionViewCell {
    
    // MARK: - UI components
    
    let menuTitle = UILabel()
        .then {
            $0.font = .systemFont(ofSize: 15)
            $0.textColor = .gray
        }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func layoutView() {
        contentView.addSubview(menuTitle)
        
        menuTitle.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }
    }
    
    // MARK: - Override Function
    
    /// Set button highlighted status
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 14)
                    $0.textColor = .black
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 14)
                    $0.textColor = .gray
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 14)
                    $0.textColor = .black
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 14)
                    $0.textColor = .gray
                }
            }
        }
    }
    
}
