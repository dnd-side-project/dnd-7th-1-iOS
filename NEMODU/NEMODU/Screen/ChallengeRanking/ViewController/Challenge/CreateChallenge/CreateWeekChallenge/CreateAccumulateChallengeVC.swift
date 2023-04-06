//
//  CreateAccumulateChallengeVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/09/13.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class CreateAccumulateChallengeVC: CreateWeekChallengeVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        _ = challengeTypeTitleButtonView
            .then {
                $0.titleLabel.text = "칸 많이 누적하기 챌린지"
            }
    }
    
    override func didTapConfirmButton() {
        requestCreateWeekChallenge(type: ChallengeType.accumulate.description)
    }
    
}
