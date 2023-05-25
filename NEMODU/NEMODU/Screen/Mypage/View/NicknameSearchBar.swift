//
//  NicknameSearchBar.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameSearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSearchBar()
        configureLayout()
        bindSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure & Layout

extension NicknameSearchBar{
    private func configureSearchBar() {
        backgroundImage = UIImage()
        searchBarStyle = .prominent
        tintColor = .main
        searchTextField.font = .body3
        searchTextField.textColor = .gray900
        searchTextField.placeholder = "닉네임으로 검색"
        searchTextField.backgroundColor = .gray50
    }
    
    private func bindSearchBar() {
        self.rx.searchButtonClicked
            .asSignal()
            .filter({(self.text?.count ?? 0) > 1})
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        searchTextField.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
    }
}
