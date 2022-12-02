//
//  ProgressChallengeDetailTVHV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ProgressChallengeDetailTVHV : ChallengeDetailTVHV {
    
    // MARK: - UI components
    
    private let dDayTextLabel = UILabel()
        .then {
            $0.text = "D-"
            $0.textAlignment = .center
            $0.textColor = .main
            
            $0.font = UIFont(name: "Pretendard-Bold", size: 14)
            $0.backgroundColor = .main.withAlphaComponent(0.2)
            
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
    private let dDayTextTriangleView = UIView()
    
    private let progressStatusContainerView = UIView()
    private let progressBarWrapperView = UIView()
        .then {
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
    private let progressBarStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 1
            $0.alignment = .fill
            $0.distribution = .fillEqually
            
            $0.backgroundColor = .white
        }
    private let progressBlackBarStackView = UIStackView()
        .then {
            $0.backgroundColor = .black
        }
    
    private let startLabel = UILabel()
        .then {
            $0.textColor = .gray800
            $0.font = .caption1
            
            $0.text = "--.-- 부터"
        }
    private let endLabel = UILabel()
        .then {
            $0.textColor = .gray800
            $0.font = .caption1
            
            $0.text = "--.-- 까지"
        }
    
    private let guideLabel = UILabel()
        .then {
            $0.textColor = .gray800
            $0.font = .caption1
            
            let attributedText = NSMutableAttributedString(string: "종료일까지 ", attributes: [NSAttributedString.Key.font: UIFont.body4,
                                                                                          NSAttributedString.Key.foregroundColor: UIColor.gray900])
            attributedText.append(NSAttributedString(string: "-일 --:--", attributes: [NSAttributedString.Key.font: UIFont.caption1,
                                                                                                          NSAttributedString.Key.foregroundColor: UIColor.main]))
            attributedText.append(NSAttributedString(string: " 남았습니다!", attributes: [NSAttributedString.Key.font: UIFont.caption1,
                                                                                                          NSAttributedString.Key.foregroundColor: UIColor.gray900]))
            $0.attributedText = attributedText
        }
    
    private let borderLineView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }
    
    private let scoreTitleLabel = PaddingLabel()
        .then {
            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            $0.text = "점수 현황"
            $0.font = .body1
            $0.textColor = .gray900
            
            $0.backgroundColor = .white
        }
    private let updateStatusLabel = UILabel()
        .then {
            $0.text = "--:-- 기준"
            $0.textColor = .gray600
            $0.font = .body3
        }
    private let updateButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "update"), for: .normal)
        }
    private var miniMap = MiniMapVC()
    
    // MARK: - Variables and Properties
    
    let tmpDDayNum = 7
    
    // MARK: - Life Cycle
    
    override func configureHV() {
        super.configureHV()
        
        configureTriangleView()
        configureProgressBarStackView()
    }
    
    // MARK: - Function
    
    override func configureLayoutView() {
        super.configureLayoutView()
        
        contentView.addSubviews([progressStatusContainerView,
                                borderLineView])
        progressStatusContainerView.addSubviews([dDayTextLabel, dDayTextTriangleView,
                                                 progressBarWrapperView,
                                                 startLabel, endLabel,
                                                 guideLabel,
                                                 scoreTitleLabel, updateStatusLabel, updateButton,
                                                 miniMap.view])
        progressBarWrapperView.addSubviews([progressBarStackView, progressBlackBarStackView])
        
        
        progressStatusContainerView.snp.makeConstraints {
            $0.height.equalTo(134)
            
            $0.top.equalTo(currentStateLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(contentView)
        }
        dDayTextLabel.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(25.3)
            
            $0.centerX.equalTo(dDayTextTriangleView)
            $0.bottom.equalTo(dDayTextTriangleView.snp.top)
        }
        dDayTextTriangleView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(6.7)
            
            $0.centerX.equalTo(progressBlackBarStackView.snp.right)
            $0.bottom.equalTo(progressBarWrapperView.snp.top).inset(-8)
        }
        progressBarWrapperView.snp.makeConstraints {
            $0.height.equalTo(progressBarWrapperView.layer.cornerRadius * 2)

            $0.top.equalTo(progressStatusContainerView.snp.top).offset(64)
            $0.left.right.equalTo(progressStatusContainerView).inset(16)
        }
        progressBarStackView.snp.makeConstraints {
            $0.edges.equalTo(progressBarWrapperView)
        }
        progressBlackBarStackView.snp.makeConstraints {
            let bar = (Int(UIScreen.main.bounds.size.width) - 16*2 - 6) / 7
            let pastDay = 7 - tmpDDayNum
            let spaceBetweenBar = pastDay - 1
            let length = (bar * pastDay) + (1 * spaceBetweenBar)
            $0.width.equalTo(length)
            
            $0.top.left.bottom.equalTo(progressBarWrapperView)
        }
        
        startLabel.snp.makeConstraints {
            $0.top.equalTo(progressBarWrapperView.snp.bottom).offset(8)
            $0.left.equalTo(progressBarWrapperView.snp.left)
        }
        endLabel.snp.makeConstraints {
            $0.top.equalTo(startLabel)
            $0.right.equalTo(progressBarWrapperView.snp.right)
        }
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(startLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(progressBarWrapperView)
            $0.bottom.equalTo(progressStatusContainerView.snp.bottom).inset(16)
        }
        
        borderLineView.snp.makeConstraints {
            $0.height.equalTo(8)
            
            $0.top.equalTo(progressStatusContainerView.snp.bottom)
            $0.horizontalEdges.equalTo(contentView)
        }
        
        scoreTitleLabel.snp.makeConstraints {
            $0.height.equalTo(56)
            
            $0.top.equalTo(borderLineView.snp.bottom)
            $0.left.equalTo(contentView.snp.left)
        }
        updateStatusLabel.snp.makeConstraints {
            $0.centerY.equalTo(scoreTitleLabel)
            $0.left.equalTo(scoreTitleLabel.snp.right)
        }
        updateButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            
            $0.centerY.equalTo(updateStatusLabel)
            $0.left.equalTo(updateStatusLabel.snp.right).offset(4)
            $0.right.equalTo(contentView.snp.right).inset(16)
        }
        miniMap.view.snp.makeConstraints {
            $0.height.equalTo(miniMap.view.snp.width).multipliedBy(0.76)
            
            $0.top.equalTo(scoreTitleLabel.snp.bottom)
            $0.horizontalEdges.equalTo(contentView).inset(16)
            $0.bottom.equalTo(contentView.snp.bottom).inset(12)
        }
    }
    
}

// MARK: - Configure

extension ProgressChallengeDetailTVHV {
    
    private func configureTriangleView() {
        let path = CGMutablePath()
        
        let width: CGFloat = 13
        let height: CGFloat = 6.7
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.main.withAlphaComponent(0.2).cgColor
        
        dDayTextTriangleView.layer.insertSublayer(shape, at: 0)
    }
    
    private func configureProgressBarStackView() {
        for _ in 1...7 {
            let view = UIView()
            view.backgroundColor = .gray200
            progressBarStackView.addArrangedSubview(view)
        }
    }
    
}

// MARK: - Input

extension ProgressChallengeDetailTVHV {
    
}

// MARK: - Output

extension ProgressChallengeDetailTVHV {
    
}
