//
//  ChallengeDoingTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/19.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeDoingTVC : ChallengeListTVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    override func configureView() {
        super.configureView()
        
        _ = challengeNameImage
            .then {
                $0.image = UIImage(named: "badge_red")
            }
        
        _ = currentStateLabel
            .then {
                $0.text = "현재 순위: -위"
            }
        _ = currentJoinUserLabel
            .then {
                $0.text = "-/-"
            }
    }
    
    override func layoutView() {
        super.layoutView()
        
        // remove for hide
        dDayLabel.snp.makeConstraints {
            $0.width.equalTo(0)
        }
    }
    
}
