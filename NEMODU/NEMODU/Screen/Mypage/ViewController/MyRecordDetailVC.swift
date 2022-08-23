//
//  MyRecordDetailVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/23.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import RxDataSources
import SnapKit
import Then

class MyRecordDetailVC: BaseViewController {
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
    
    private let recordDate = UILabel()
        .then {
            $0.text = "-월 -일 -요일"
            $0.textAlignment = .center
            $0.font = .title3SB
            $0.textColor = .gray900
        }
    
    private let recordTime = UILabel()
        .then {
            $0.text = "--:-- ~ --:--"
            $0.textAlignment = .center
            $0.font = .body1
            $0.textColor = .gray600
        }
    
    private var blocksCntView = RecordView()
        .then {
            $0.recordValue.font = .number1
            $0.recordTitle.font = .body3
            $0.recordSubtitle.font = .body4
            $0.recordValue.text = "-"
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
    
    private let memoEditBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "edit"), for: .normal)
        }
    
    private let memoTextView = NemoduTextView()
        .then {
            $0.tv.placeholder = "상세 기록 남기기"
            $0.tv.backgroundColor = .systemBackground
            $0.tv.layer.borderColor = UIColor.gray200.cgColor
            $0.tv.setTextViewToViewer()
        }
    
    private let proceedingChallengeTV = UITableView(frame: .zero)
        .then {
            $0.isScrollEnabled = false
            $0.separatorStyle = .singleLine
            $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.backgroundColor = .white
        }
    
    private let naviBar = NavigationBar()
    private let viewModel = MyRecordDetailVM()
    private let bag = DisposeBag()
    var recordID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let recordID = recordID else {
            // TODO: - ERROR Alert 띄우기
            return
        }
        viewModel.getMyRecordDetailData(recordId: recordID)
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
        configureChallengeListTV()
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
        bindRecordData()
    }
    
}

// MARK: - Configure

extension MyRecordDetailVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self, title: nil)
        naviBar.configureBackBtn(targetVC: self)
    }
    
    private func configureContentView() {
        addChild(miniMap)
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(contentView)
        contentView.addSubviews([recordBaseView,
                                 memoView])
        recordBaseView.addSubviews([recordDate,
                                    recordTime,
                                    blocksCntView,
                                    miniMap.view,
                                    recordStackView])
        memoView.addSubviews([memoLabel,
                              memoEditBtn,
                              viewSeparator,
                              memoTextView])
    }
    
    private func configureChallengeListTV() {
        contentView.addSubview(proceedingChallengeTV)
        
        proceedingChallengeTV.register(ProceedingChallengeTVC.self,
                                       forCellReuseIdentifier: ProceedingChallengeTVC.className)
        proceedingChallengeTV.delegate = self
    }
    
    private func configureRecordValue(recordData: DetailRecordDataResponseModel) {
        recordDate.text = recordData.date
        recordTime.text = recordData.started + "-" + recordData.ended
        blocksCntView.recordValue.text = "\(recordData.matrixNumber)"
        miniMap.blocks = changeMatriesToBlocks(matrices: recordData.matrices)
        miniMap.drawMiniMap()
        recordStackView.firstView.recordValue.text = "\(recordData.distance)m"
        recordStackView.secondView.recordValue.text = recordData.exerciseTime
        recordStackView.thirdView.recordValue.text = "\(recordData.stepCount)".insertComma
        memoTextView.tv.text = recordData.message
    }
    
    private func changeMatriesToBlocks(matrices: [Matrix]) -> [[Double]] {
        var blocks: [[Double]] = []
        matrices.forEach {
            blocks.append([$0.latitude, $0.longitude])
        }
        return blocks
    }
}

// MARK: - Layout

extension MyRecordDetailVC {
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
        
        recordDate.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        recordTime.snp.makeConstraints {
            $0.top.equalTo(recordDate.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        blocksCntView.snp.makeConstraints {
            $0.top.equalTo(recordTime.snp.bottom).offset(24)
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
        
        memoEditBtn.snp.makeConstraints {
            $0.centerY.equalTo(memoLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.width.equalTo(24)
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
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        proceedingChallengeTV.snp.makeConstraints {
            $0.top.equalTo(memoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-47)
        }
    }
}

// MARK: - Input

extension MyRecordDetailVC {
    
}

// MARK: - Output

extension MyRecordDetailVC {
    private func bindRecordData() {
        viewModel.output.detailData
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.configureRecordValue(recordData: data)
            })
            .disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate

extension MyRecordDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        69.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
