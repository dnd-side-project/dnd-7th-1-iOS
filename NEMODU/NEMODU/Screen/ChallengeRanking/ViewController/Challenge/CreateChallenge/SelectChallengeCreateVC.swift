//
//  SelectChallengeCreateVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/21.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SelectChallengeCreateVC: SelectChallengeTypeVC {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()

        _ = navigationBar
            .then {
                $0.configureNaviBar(targetVC: self, title: "챌린지 만들기")
                $0.configureBackBtn(targetVC: self)
            }
        
        _ = titleLabel
            .then {
                $0.text = "챌린지 종류 선택"
            }
        
        _ = button1
            .then {
                $0.iconImageView.image = UIImage(named: "weekChallenge")?.withRenderingMode(.alwaysTemplate)
                $0.titleLabel.text = "주간 챌린지"
                $0.explainTextView.text = "시작 날짜부터 이번 주말 자정까지 각자의 기록을 가지고 대결해요!"
            }
        _ = button2
            .then {
                $0.iconImageView.image = UIImage(named: "realTimeEatingGround")?.withRenderingMode(.alwaysTemplate)
                $0.titleLabel.text = "실시간 땅따먹기"
                $0.explainTextView.text = "최대 20분 동안 친구와 함께 서로의 땅을 먹고 먹으며 경쟁하는 땅따먹기 게임 입니다."
            }
        
    }
    
    override func layoutView() {
        super.layoutView()
    }
    
    @objc
    override func didTapConfirmButton() {
        super.didTapConfirmButton()
        
        switch true {
        case button1.button.isSelected:
            let selectWeekChallengeCreateVC = SelectWeekChallengeCreateVC()
            navigationController?.pushViewController(selectWeekChallengeCreateVC, animated: true)
            
        case button2.button.isSelected: // TODO: - MVP2 실시간 챌린지
            // TODO: - AlertSheet custom 지정
            
            break
        default:
            break
        }
    }
    
}
