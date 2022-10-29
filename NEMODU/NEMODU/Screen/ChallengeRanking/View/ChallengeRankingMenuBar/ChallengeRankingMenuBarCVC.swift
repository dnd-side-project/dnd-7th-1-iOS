//
//  ChallengeRankingMenuBarCVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/02.
//

import UIKit
import Then
import SnapKit

class ChallengeRankingMenuBarCVC: MenuBarCVC {
    
    // MARK: - Functions
    
    override func setSameFont() {
        _ = menuTitle
            .then {
                $0.font = .headline1
                $0.textColor = .gray400
            }
    }
    
}

// MARK: - Override Function

extension ChallengeRankingMenuBarCVC {
    
    /// Set button highlighted status
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .headline1
                    $0.textColor = .gray900
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .headline1
                    $0.textColor = .gray400
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .headline1
                    $0.textColor = .gray900
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .headline1
                    $0.textColor = .gray400
                }
            }
        }
    }

}
