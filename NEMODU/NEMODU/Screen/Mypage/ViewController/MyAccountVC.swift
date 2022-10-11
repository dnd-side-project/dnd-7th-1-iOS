//
//  MyAccountVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/11.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class MyAccountVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let titleLabel = UILabel()
        .then {
            $0.text = "이메일"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let emailTextField = UITextField()
        .then {
            $0.text = "-"
            $0.textColor = .gray500
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 8
            $0.isUserInteractionEnabled = false
            $0.addLeftPadding()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension MyAccountVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: "계정 정보")
        naviBar.configureBackBtn(targetVC: self)
    }
    
    private func configureContentView() {
        view.addSubviews([titleLabel,
                          emailTextField])
        
    }
}

// MARK: - Layout

extension MyAccountVC {
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(56)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(42)
        }
    }
}

// MARK: - Input

extension MyAccountVC {
    
}

// MARK: - Output

extension MyAccountVC {
    
}
