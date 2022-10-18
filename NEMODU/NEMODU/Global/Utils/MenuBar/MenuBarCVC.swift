//
//  MenuBarCVCell.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import Then
import SnapKit

class MenuBarCVC: BaseCollectionViewCell {
    
    // MARK: - UI components
    
    let menuTitle = UILabel()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        setSameFont()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
    // 최초 실행시 기본설정 폰트가 안 맞는 문제를 방지하기 위해 최초 셀의 폰트와 색깔을 override한 isHighlighted, isSelect와의 통일
    func setSameFont() {
        _ = menuTitle
            .then {
                $0.font = .systemFont(ofSize: 17)
                $0.textColor = .gray
            }
    }
}

// MARK: - Configure

extension MenuBarCVC {
    
}

// MARK: - Layout

extension MenuBarCVC {
    
    private func configureLayout() {
        contentView.addSubview(menuTitle)
        
        menuTitle.snp.makeConstraints {
            $0.center.equalTo(contentView)
        }
    }
    
}

// MARK: - Override Function

extension MenuBarCVC {
    
    /// Set button highlighted status
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 17)
                    $0.textColor = .black
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 17)
                    $0.textColor = .gray
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 17)
                    $0.textColor = .black
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 17)
                    $0.textColor = .gray
                }
            }
        }
    }
    
}
