//
//  ChallengeVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/29.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class ChallengeVC: BaseViewController {
    private var tmp = UILabel()
        .then {
            $0.text = "CHALLENGE"
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureLabel()
    }
    
    override func layoutView() {
        super.layoutView()
        labelLayout()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension ChallengeVC {
    private func configureLabel() {
        view.addSubview(tmp)
    }
}

// MARK: - Layout

extension ChallengeVC {
    private func labelLayout() {
        tmp.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Input

extension ChallengeVC {
    
}

// MARK: - Output

extension ChallengeVC {
    
}
