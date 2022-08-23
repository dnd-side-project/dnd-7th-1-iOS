//
//  NemoduTextView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import UITextView_Placeholder

class NemoduTextView: BaseView {
    let tv = UITextView()
        .then {
            $0.placeholderColor = .gray600
            $0.font = .caption1
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.setPadding()
        }
    
    private let memoCntLabel = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray600
            $0.textAlignment = .right
        }
    
    var maxTextCnt = 100
    private let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
    private let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
    private let bag = DisposeBag()
    
    override func configureView() {
        super.configureView()
        configureContentView()
        bindTextCnt()
        bindTextViewActivate()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
}

// MARK: - Configure

extension NemoduTextView {
    private func configureContentView() {
        addSubviews([tv, memoCntLabel])
        memoCntLabel.text = "0 / \(maxTextCnt)"
    }
    
    /// setTextViewToViewer - textView를 드래그 불가 뷰어용으로 설정 & cnt 라벨 hidden
    func setTextViewToViewer() {
        tv.setTextViewToViewer()
        memoCntLabel.isHidden = true
        
        memoCntLabel.snp.removeConstraints()
        tv.snp.makeConstraints {
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Layout

extension NemoduTextView {
    private func configureLayout() {
        tv.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        memoCntLabel.snp.makeConstraints {
            $0.top.equalTo(tv.snp.bottom).offset(8)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(13)
        }
    }
}

// MARK: - Input

extension NemoduTextView {
    private func bindTextCnt() {
        tv.rx.text
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self,
                let text = text else { return }
                if text.count > self.maxTextCnt {
                    self.tv.text.removeLast()
                } else {
                    self.memoCntLabel.text = "\(text.count) / \(self.maxTextCnt)"
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension NemoduTextView {
    private func bindTextViewActivate() {
        keyboardWillShow
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tv.layer.borderColor = UIColor.secondary.cgColor
            })
            .disposed(by: bag)
        
        keyboardWillHide
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tv.layer.borderColor = UIColor.clear.cgColor
            })
            .disposed(by: bag)
    }
}
