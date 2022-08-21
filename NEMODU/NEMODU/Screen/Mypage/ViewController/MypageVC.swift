//
//  MypageVC.swift
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

class MypageVC: BaseViewController {
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .gray50
        }
    
    private let dataView = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }
    
    private let btnView = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }
    
    private let profileView = ProfileView()
    
    private let blockCntView = BlockCntView()
    
    private let recordView = RecordStackView()
        .then {
            $0.configureStackViewTitle(title: "이번주 기록")
            $0.firstView.recordTitle.text = "영역"
            $0.secondView.recordTitle.text = "걸음수"
            $0.thirdView.recordTitle.text = "거리"
            $0.firstView.recordValue.text = "- 칸"
            $0.secondView.recordValue.text = "-"
            $0.thirdView.recordValue.text = "- m"
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 8
        }
    
    private let naviBar = NavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureMypage()
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

extension MypageVC {
    private func configureNaviBar() {
        naviBar.configureNaviBar(targetVC: self,
                                 title: "마이페이지")
        naviBar.configureRightBarBtn(targetVC: self,
                                     image: UIImage(named: "bell")!)
    }
    
    private func configureMypage() {
        view.addSubview(baseScrollView)
        baseScrollView.addSubviews([dataView,
                                    btnView])
        dataView.addSubviews([profileView,
                              blockCntView,
                              recordView])
    }
}

// MARK: - Layout

extension MypageVC {
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        dataView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(307)
        }
        
        btnView.snp.makeConstraints {
            $0.top.equalTo(dataView.snp.bottom).offset(8)
            $0.height.equalTo(430)
            $0.width.bottom.equalToSuperview()
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        blockCntView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(57)
        }
        
        recordView.snp.makeConstraints {
            $0.top.equalTo(blockCntView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(114)
        }
    }
}

// MARK: - Input

extension MypageVC {
    
}

// MARK: - Output

extension MypageVC {
    
}
