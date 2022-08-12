//
//  RecodeResultVC.swift
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

class RecodeResultVC: BaseViewController {
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }
    
    private let contentView = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    private let recodeBaseView = UIView()
        .then {
            $0.backgroundColor = UIColor.systemBackground
        }
    
    private let memoView = UIView()
        .then {
            $0.backgroundColor = UIColor.systemBackground
        }
    
    private var blocksCntView = RecodeView()
        .then {
            $0.recodeValue.font = .number1
            $0.recodeTitle.font = .body3
            $0.recodeSubtitle.font = .body4
            $0.recodeTitle.text = "채운 칸의 수"
        }
    
    private var miniMap = MiniMapVC()
    
    private let recodeStackView = RecodeStackView()
    
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
    private let bag = DisposeBag()
    
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
        bindDismissBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindKeyboardScroll()
    }
    
}

// MARK: - Configure

extension RecodeResultVC {
    private func configureNaviBar() {
        view.addSubview(naviBar)
        let month = Calendar.current.component(.month, from: Date.now)
        let day = Calendar.current.component(.day, from: Date.now)
        naviBar.naviType = .present
        naviBar.configureNaviBar(targetVC: self,
                                 title: "\(month)월 \(day)일의 기록")
        naviBar.configureRightBarBtn(targetVC: self,
                                     image: naviBar.naviType.backBtnImage)
    }
    
    private func configureContentView() {
        addChild(miniMap)
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(contentView)
        contentView.addSubviews([recodeBaseView,
                                 memoView])
        recodeBaseView.addSubviews([blocksCntView,
                                    miniMap.view,
                                    recodeStackView])
        memoView.addSubviews([memoLabel,
                              viewSeparator,
                              memoTextView])
    }
    
    func configureRecodeValue(recodeBlockCnt: Int, weekBlockCnt: Int, distance: Int, second: Int, stepCnt: Int) {
        blocksCntView.recodeValue.text = "\(recodeBlockCnt)"
        blocksCntView.recodeSubtitle.text = "이번주 영역 : \(weekBlockCnt + recodeBlockCnt)칸"
        recodeStackView.distanceView.recodeValue.text = "\(distance)m"
        recodeStackView.timeView.recodeValue.text = "\(second / 60):" + String(format: "%02d", second % 60)
        recodeStackView.stepCntView.recodeValue.text = "\(stepCnt)"
    }
}

// MARK: - Layout

extension RecodeResultVC {
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
        
        recodeBaseView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        memoView.snp.makeConstraints {
            $0.top.equalTo(recodeBaseView.snp.bottom).offset(8)
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
        
        recodeStackView.snp.makeConstraints {
            $0.top.equalTo(miniMap.view.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
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

extension RecodeResultVC {
    private func bindDismissBtn() {
        // dismiss to rootViewController
        naviBar.rightBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension RecodeResultVC {
    private func bindKeyboardScroll() {
        keyboardWillShow
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.baseScrollView.scrollToBottom(animated: true)
            })
            .disposed(by: bag)
    }
}
