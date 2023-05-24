//
//  RecordResultVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/10.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import CoreLocation

class RecordResultVC: BaseViewController {
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }
    
    private let contentView = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    private let recordBaseView = UIView()
        .then {
            $0.backgroundColor = UIColor.systemBackground
        }
    
    private let memoView = UIView()
        .then {
            $0.backgroundColor = UIColor.systemBackground
        }
    
    private var blocksCntView = RecordView()
        .then {
            $0.recordValue.font = .number1
            $0.recordTitle.font = .body3
            $0.recordSubtitle.font = .body4
            $0.recordTitle.text = "채운 칸의 수"
        }
    
    private var miniMap = MiniMapVC()
    
    private let recordStackView = RecordStackView()
        .then {
            $0.firstView.recordTitle.text = "거리"
            $0.secondView.recordTitle.text = "시간"
            $0.thirdView.recordTitle.text = "걸음수"
        }
    
    private let viewSeparator = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    private let memoLabel = UILabel()
        .then {
            $0.text = "상세 기록"
            $0.font = .body2
            $0.textColor = .gray900
        }
    
    private let memoTextView = NemoduTextView()
        .then {
            $0.tv.placeholder = "상세 기록 남기기"
        }
    
    private let naviBar = NavigationBar()
    private let viewModel = RecordResultVM()
    private var recordData: RecordDataRequest?
    
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
        bindSaveBtn()
        bindMyDetailMap()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindAPIErrorAlert(viewModel)
        bindKeyboardScroll()
        bindPostResult()
    }
    
    override func bindLoading() {
        super.bindLoading()
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.loading(loading: isLoading)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure

extension RecordResultVC {
    private func configureNaviBar() {
        view.addSubview(naviBar)
        let month = Date.now.month
        let day = Date.now.day
        naviBar.naviType = .present
        naviBar.configureNaviBar(targetVC: self,
                                 title: "\(month)월 \(day)일의 기록")
        naviBar.configureRightBarBtn(targetVC: self,
                                     title: "저장",
                                     titleColor: .main)
    }
    
    private func configureContentView() {
        addChild(miniMap)
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(contentView)
        contentView.addSubviews([recordBaseView,
                                 memoView])
        recordBaseView.addSubviews([blocksCntView,
                                    miniMap.view,
                                    recordStackView])
        memoView.addSubviews([memoLabel,
                              viewSeparator,
                              memoTextView])
    }
    
    /// 기록된 데이터를 통해 화면 구현. WalkingVC에서 호출
    func configureRecordValue(recordData: RecordDataRequest, weekBlockCnt: Int) {
        self.recordData = recordData
        miniMap.drawMyMapAtOnce(matrices: recordData.matrices)
        blocksCntView.recordValue.text = "\(recordData.matrices.count.insertComma)"
        blocksCntView.recordSubtitle.text = "이번주 영역 : \((weekBlockCnt + recordData.matrices.count).insertComma)칸"
        recordStackView.firstView.recordValue.text = "\(recordData.distance.toKilometer)"
        recordStackView.secondView.recordValue.text = "\(recordData.exerciseTime / 60):" + String(format: "%02d", recordData.exerciseTime % 60)
        recordStackView.thirdView.recordValue.text = "\(recordData.stepCount.insertComma)"
    }
}

// MARK: - Layout

extension RecordResultVC {
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.width.centerX.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
        }
        
        recordBaseView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        memoView.snp.makeConstraints {
            $0.top.equalTo(recordBaseView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        blocksCntView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(100)
            $0.leading.trailing.equalToSuperview()
        }
        
        miniMap.view.snp.makeConstraints {
            $0.top.equalTo(blocksCntView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(miniMap.view.snp.width).multipliedBy(0.76)
        }
        
        recordStackView.snp.makeConstraints {
            $0.top.equalTo(miniMap.view.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        viewSeparator.snp.makeConstraints {
            $0.top.equalTo(memoLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(viewSeparator.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-47)
        }
    }
}

// MARK: - Input

extension RecordResultVC {
    private func bindSaveBtn() {
        naviBar.rightBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      var recordData = self.recordData else { return }
                recordData.message = self.memoTextView.tv.text
                self.viewModel.postRecordData(with: recordData)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindMyDetailMap() {
        miniMap.magnificationBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let recordData = self.recordData else { return }
                let detailMapVC = MyDetailMapVC()
                detailMapVC.matrices = recordData.matrices
                self.navigationController?.pushViewController(detailMapVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension RecordResultVC {
    private func bindKeyboardScroll() {
        keyboardWillShow
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.baseScrollView.scrollToBottom(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindPostResult() {
        viewModel.output.isValidPost
            .subscribe(onNext: { [weak self] validation in
                guard let self = self else { return }
                validation
                ? self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                : self.viewModel.apiError.onNext(.error(ErrorResponseModel(code: "200 False",
                                                                           message: "잠시후 다시 시도해주세요 😢",
                                                                           trace: nil)))
            })
            .disposed(by: disposeBag)
    }
}
