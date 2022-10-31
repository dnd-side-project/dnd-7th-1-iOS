//
//  CreateChallengeVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/25.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class CreateChallengeVC: BaseViewController {
    
    // MARK: - UI components
    
    let navigationBar = NavigationBar()
        .then {
            $0.naviType = .push
            $0.setTitleFont(font: .title3M)
        }
    
    lazy var confirmButton = UIButton()
        .then {
            $0.setTitle("다음", for: .normal)
            
            $0.layer.cornerRadius = 10
            
            $0.setTitleColor(.gray400, for: .normal)
            $0.setTitleColor(.secondary.withAlphaComponent(0.5), for: .highlighted)
            $0.setTitleColor(.secondary, for: .selected)
            
            $0.setBackgroundColor(.gray100, for: .normal)
            $0.setBackgroundColor(.main.withAlphaComponent(0.5), for: .highlighted)
            $0.setBackgroundColor(.main, for: .selected)
            
            $0.isEnabled = false
            
            $0.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
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
        
        view.addSubviews([navigationBar, confirmButton])
        
        
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(343)
            $0.height.equalTo(48)
            
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    /// override when class inheritance for request create challenge
    @objc
    func didTapConfirmButton() {
    }
    
}
