//
//  ListTypeMenuBarCVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/18.
//

import UIKit
import Then
import SnapKit

class ListTypeMenuBarCVC: MenuBarCVC {
    
    // MARK: - UI components
    
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func configureCell() {
        _ = menuTitle
            .then {
                $0.font = .title3SB
                $0.textColor = .gray400
            }
    }
    
    // MARK: - Override Function
    
    /// Set button highlighted status
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .title3SB
                    $0.textColor = .gray900
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .title3SB
                    $0.textColor = .gray400
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .title3SB
                    $0.textColor = .gray900
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .title3SB
                    $0.textColor = .gray400
                }
            }
        }
    }

}
