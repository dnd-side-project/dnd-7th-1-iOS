//
//  NicknameVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/08.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class NicknameVC: BaseViewController {
    private let tmpBtn = UIButton()
        .then {
            $0.setTitle("회원가입 완료", for: .normal)
            $0.tintColor = .black
        }
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension NicknameVC {
    private func configureContentView() {
        view.addSubviews([tmpBtn])
    }
}

// MARK: - Layout

extension NicknameVC {
    private func configureLayout() {
        tmpBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Input

extension NicknameVC {
    private func bindBtn() {
        tmpBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                // TODO: - 서버 연결 후 결과값으로 수정
                UserDefaults.standard.set("tempToken", forKey: UserDefaults.Keys.refreshToken)
                UserDefaults.standard.set("희재횽아짱", forKey: UserDefaults.Keys.nickname)
                self.setTBCtoRootVC()
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension NicknameVC {
    
}
