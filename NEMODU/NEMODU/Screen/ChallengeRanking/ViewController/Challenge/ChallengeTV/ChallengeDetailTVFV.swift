//
//  ChallengeDetailTVFV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/26.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeDetailTVFV : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    private let titleLabel = PaddingLabel()
        .then {
            $0.text = "나의 기록"
            $0.font = .body2
            $0.textColor = .gray900
            
            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    private let recordStackView = RecordStackView()
        .then {
            $0.firstView.recordTitle.text = "거리"
            $0.secondView.recordTitle.text = "시간"
            $0.thirdView.recordTitle.text = "걸음수"
            
            $0.firstView.recordValue.text = "-"
            $0.secondView.recordValue.text = "-"
            $0.thirdView.recordValue.text = "-"
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureFV()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
}

// MARK: - Configure

extension ChallengeDetailTVFV {
    
    private func configureFV() {
        contentView.backgroundColor = .white
    }
    
    func configureChallengeDetailTVFV(distance: Int, time: Int, steps: Int) {
        _ = recordStackView
            .then {
                $0.firstView.recordValue.text = "\(distance.toKilometer)"
                $0.secondView.recordValue.text = "\(time / 60):" + String(format: "%02d", time % 60)
                $0.thirdView.recordValue.text = "\(steps.insertComma)"
            }
    }
    
}

// MARK: - Layout

extension ChallengeDetailTVFV {
    
    private func layoutView() {
        contentView.addSubviews([titleLabel,
                                recordStackView])
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(56).priority(.high)
            
            $0.top.horizontalEdges.equalTo(contentView)
        }
        recordStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16).priority(.high)
            $0.horizontalEdges.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(16)
        }
    }
    
}
