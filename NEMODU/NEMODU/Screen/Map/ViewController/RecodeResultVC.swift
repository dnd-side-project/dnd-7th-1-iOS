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
import MapKit
import UITextView_Placeholder

class RecodeResultVC: BaseViewController {
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }
    
    private let contentView = UIView()
    
    private var blocksCntView = RecodeView()
        .then {
            $0.recodeValue.font = .number1
            $0.recodeTitle.font = .body3
            $0.recodeSubtitle.font = .body4
            $0.recodeTitle.text = "채운 칸의 수"
        }
    
    private var miniMap = MKMapView()
        .then {
            $0.mapType = .standard
            $0.showsUserLocation = false
            $0.layer.cornerRadius = 15
        }
    
    private let recodeStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    
    private var distanceView = RecodeView()
        .then {
            $0.recodeTitle.text = "거리"
        }
    
    private var timeView = RecodeView()
        .then {
            $0.recodeTitle.text = "시간"
        }
    
    private var calorieView = RecodeView()
        .then {
            $0.recodeTitle.text = "칼로리"
        }
    
    private let memoLabel = UILabel()
        .then {
            $0.text = "상세 기록"
            $0.font = .body2
            $0.textColor = .gray900
        }
    
    private let memoTextView = UITextView()
        .then {
            $0.placeholder = "상세 기록 남기기"
            $0.placeholderColor = .gray600
            $0.font = .caption1
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 10
        }
    
    private let memoCnt = UILabel()
        .then {
            $0.text = "0 / 100"
            $0.font = .caption2R
            $0.textColor = .gray600
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
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(contentView)
        contentView.addSubviews([blocksCntView,
                          miniMap,
                          recodeStackView,
                          memoLabel,
                          memoTextView,
                          memoCnt])
        [distanceView, timeView, calorieView].forEach {
            recodeStackView.addArrangedSubview($0)
        }
    }
    
    func configureRecodeValue(recodeBlockCnt: Int, weekBlockCnt: Int, distance: Int, second: Int) {
        blocksCntView.recodeValue.text = "\(recodeBlockCnt)"
        blocksCntView.recodeSubtitle.text = "이번주 영역 : \(weekBlockCnt + recodeBlockCnt)칸"
        distanceView.recodeValue.text = "\(distance)m"
        timeView.recodeValue.text = "\(second / 60):" + String(format: "%02d", second % 60)
        calorieView.recodeValue.text = "0"
    }
}

// MARK: - Layout

extension RecodeResultVC {
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.width.centerX.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
        }
        
        blocksCntView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(106)
            $0.leading.trailing.equalToSuperview()
        }
        
        miniMap.snp.makeConstraints {
            $0.top.equalTo(blocksCntView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(miniMap.snp.width).multipliedBy(0.76)
        }
        
        recodeStackView.snp.makeConstraints {
            $0.top.equalTo(miniMap.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(65)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(recodeStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(memoLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(100)
        }
        
        memoCnt.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-89)
        }
    }
}

// MARK: - Input

extension RecodeResultVC {
    func bindDismissBtn() {
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
    
}
