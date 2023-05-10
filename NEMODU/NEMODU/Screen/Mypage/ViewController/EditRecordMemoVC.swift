//
//  EditRecordMemoVC.swift
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

class EditRecordMemoVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let memoTextView = NemoduTextView()
        .then {
            $0.tv.placeholder = "상세 기록 남기기"
            $0.maxTextCnt = 100
        }
    
    private let viewModel = EditRecordMemoVM()
    private let bag = DisposeBag()
    weak var delegate: RecordMemoChanged?
    
    private var memo = ""
    private var recordId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInteractivePopGesture(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setInteractivePopGesture(true)
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
        bindBackBtn()
        bindSaveBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindDismiss()
    }
    
}

// MARK: - Configure

extension EditRecordMemoVC {
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
    
    func getRecordData(recordId: Int, memo: String) {
        self.recordId = recordId
        self.memo = memo
    }
}

// MARK: - Layout

extension EditRecordMemoVC {
    private func configureLayout() {
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

// MARK: - Input

extension EditRecordMemoVC {
    private func bindSaveBtn() {
        naviBar.rightBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.memoTextView.tv.text == self.memo {
                    self.popVC()
                } else {
                    self.viewModel.postEditedData(with: EditMemoRequestModel(message: self.memoTextView.tv.text,
                                                                             recordId: self.recordId))
                }
            })
            .disposed(by: bag)
    }
    
    private func bindBackBtn() {
        // 기존 뒤로가기 pop 액션 remove
        naviBar.backBtn.removeTarget(self,
                                     action: #selector(self.popVC),
                                     for: .touchUpInside)
        // 값 상태에 따라 binding
        naviBar.backBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.memoTextView.tv.text != self.memo {
                    self.popUpAlert(alertType: .discardChanges,
                                    targetVC: self,
                                    highlightBtnAction: #selector(self.dismissAlertAndPopVC),
                                    normalBtnAction: #selector(self.dismissAlert))
                } else {
                    self.popVC()
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension EditRecordMemoVC {
    private func bindDismiss() {
        viewModel.output.isValidEdit
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] validation in
                guard let self = self else { return }
                if validation {
                    self.popVC()
                    self.delegate?.popupToastView()
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - RecordMemoChanged Protocol

protocol RecordMemoChanged: AnyObject {
    func popupToastView()
}
