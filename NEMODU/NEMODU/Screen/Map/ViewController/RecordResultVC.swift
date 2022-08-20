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
    private var blocks: [[Double]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
        configureMiniMap()
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

extension RecordResultVC {
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
        contentView.addSubviews([recordBaseView,
                                 memoView])
        recordBaseView.addSubviews([blocksCntView,
                                    miniMap.view,
                                    recordStackView])
        memoView.addSubviews([memoLabel,
                              viewSeparator,
                              memoTextView])
    }
    
    private func configureMiniMap() {
        guard let blocks = blocks else { return }
        
        let sortedLatitude = blocks.sorted(by: { $0[0] < $1[0] })
        let sortedLongitude = blocks.sorted(by: { $0[1] < $1[1] })
        
        _ = miniMap.goLocation(latitudeValue: sortedLatitude[blocks.count/2][0],
                               longitudeValue: sortedLongitude[blocks.count/2][1] - 0.0001,
                               delta: 0.003)
        
        blocks.forEach {
            miniMap.drawBlock(latitude: $0[0],
                              longitude: $0[1],
                              color: .main30)
        }
    }
    
    func configureRecordValue(blocks: [[Double]], weekBlockCnt: Int, distance: Int, second: Int, stepCnt: Int) {
        self.blocks = blocks
        blocksCntView.recordValue.text = "\(blocks.count)"
        blocksCntView.recordSubtitle.text = "이번주 영역 : \(weekBlockCnt + blocks.count)칸"
        recordStackView.distanceView.recordValue.text = "\(distance)m"
        recordStackView.timeView.recordValue.text = "\(second / 60):" + String(format: "%02d", second % 60)
        recordStackView.stepCntView.recordValue.text = "\(stepCnt)"
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

extension RecordResultVC {
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

extension RecordResultVC {
    private func bindKeyboardScroll() {
        keyboardWillShow
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.baseScrollView.scrollToBottom(animated: true)
            })
            .disposed(by: bag)
    }
}
