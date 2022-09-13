//
//  SelectWeekChallengeCreateVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/24.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SelectWeekChallengeCreateVC: SelectChallengeTypeVC {
    
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
                $0.configureNaviBar(targetVC: self, title: "일주일 챌린지 만들기")
                $0.configureBackBtn(targetVC: self)
            }
        
        _ = titleLabel
            .then {
                $0.text = "점수 기준 설정"
            }
        
        _ = button1
            .then {
                $0.iconImageView.image = UIImage(named: "widenBlocks")?.withRenderingMode(.alwaysTemplate)
                $0.titleLabel.text = "영역 넓히기"
                $0.explainTextView.text = "지도 상에 영역을 넓혀 많은 칸을 차지하는 사용자가 이깁니다. 새로운 곳을 더 탐방해보세요!"
            }
        _ = button2
            .then {
                $0.iconImageView.image = UIImage(named: "footPrint")?.withRenderingMode(.alwaysTemplate)
                $0.titleLabel.text = "칸 많이 누적하기"
                $0.explainTextView.text = "기록마다 채운 칸 수를 누적해 많은 칸을 기록한 사용자가 이깁니다. 활동 기록을 최대한 많이 해보세요!"
            }
        
        _ = confirmButton
            .then {
                $0.setTitle("완료", for: .normal)
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
            let createWidenChallengeVC = CreateWidenChallengeVC()
            navigationController?.pushViewController(createWidenChallengeVC, animated: true)
            
        case button2.button.isSelected:
            let createAccumulateChallengeVC = CreateAccumulateChallengeVC()
            navigationController?.pushViewController(createAccumulateChallengeVC, animated: true)
            
        default:
            break
        }    
    }
    
}
