//
//  EditRecordMomoVC.swift
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

class EditRecordMomoVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let memoTextView = NemoduTextView()
        .then {
            $0.tv.placeholder = "상세 기록 남기기"
            $0.maxTextCnt = 100
        }
    
    var memo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
        configureNaviBar()
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

extension EditRecordMomoVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: "활동 상세 기록 수정")
        naviBar.configureBackBtn(targetVC: self)
        naviBar.configureRightBarBtn(targetVC: self,
                                     title: "저장",
                                     titleColor: .main)
    }
    
    private func configureContentView() {
        view.addSubview(memoTextView)
        memoTextView.tv.text = memo
    }
}

// MARK: - Layout

extension EditRecordMomoVC {
    private func configureLayout() {
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

// MARK: - Input

extension EditRecordMomoVC {
    
}

// MARK: - Output

extension EditRecordMomoVC {
    
}
