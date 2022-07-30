//
//  MapVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class MapVC: BaseViewController {
    private var tmp = UILabel()
        .then {
            $0.text = "MAP"
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

extension MapVC {
    private func configureLabel() {
        view.addSubview(tmp)
    }
}

// MARK: - Layout

extension MapVC {
    private func labelLayout() {
        tmp.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Input

extension MapVC {
    
}

// MARK: - Output

extension MapVC {
    
}
