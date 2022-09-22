//
//  SelectChallengeTypeVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/21.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SelectChallengeTypeVC: CreateChallengeVC {
    
    // MARK: - UI components
    
    let titleLabel = UILabel()
        .then {
            $0.textAlignment = .center
            $0.font = .body2
            $0.textColor = .gray600
        }
    
    lazy var button1 = SelectChallengeTypeButtonView()
        .then {
            $0.button.addTarget(self, action: #selector(bindButtonsAction(_:)), for: .touchUpInside)
            $0.button.tag = 1
        }
    lazy var button2 = SelectChallengeTypeButtonView()
        .then {
            $0.button.addTarget(self, action: #selector(bindButtonsAction(_:)), for: .touchUpInside)
            $0.button.tag = 2
        }

    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
        
//        view.addSubview(navigationBar)
        view.addSubviews([button1, button2])
        view.addSubviews([titleLabel])//, confirmButton])
        
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(26)
            
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view)
        }
        
        let paddingCenter: CGFloat = 12
        button1.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.right.equalTo(view.snp.left).inset(view.frame.size.width / 2 - paddingCenter / 2)
        }
        button2.snp.makeConstraints {
            $0.top.equalTo(button1)
            $0.left.equalTo(button1.snp.right).offset(paddingCenter)
        }
        
    }
    
    @objc
    func bindButtonsAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            button1.button.isSelected = true
            button2.button.isSelected = false
            
            button1.button.layer.borderColor = UIColor.main.cgColor
            button1.iconImageView.tintColor = .main.withAlphaComponent(0.5)
            
            button2.button.layer.borderColor = UIColor.clear.cgColor
            button2.iconImageView.tintColor = .gray300
        case 2:
            button2.button.isSelected = true
            button1.button.isSelected = false
            
            button2.button.layer.borderColor = UIColor.main.cgColor
            button2.iconImageView.tintColor = .main.withAlphaComponent(0.5)
            
            button1.button.layer.borderColor = UIColor.clear.cgColor
            button1.iconImageView.tintColor = .gray300
        default:
            break
        }
        
        button1.button.isSelected == true || button2.button.isSelected == true
        ? (confirmButton.isSelected = true) : (confirmButton.isSelected = false)
        
        confirmButton.isSelected == true ? (confirmButton.isEnabled = true) : (confirmButton.isEnabled = false)
    }

}
