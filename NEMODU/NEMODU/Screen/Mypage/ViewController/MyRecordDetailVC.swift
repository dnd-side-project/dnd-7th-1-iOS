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
    
    private let challengeListView = UIView()
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
    
    private let noneMemoLabel = UILabel()
        .then {
            $0.text = "상세 기록이 없습니다."
            $0.font = .caption1
            $0.textColor = .gray500
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
            $0.setTextViewToViewer()
        }
    
    private let challengeViewTitle = UILabel()
        .then {
            $0.text = "참여한 챌린지"
            $0.font = .body2
            $0.textColor = .gray900
        }
    
    private let viewSeparator2 = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    private let proceedingChallengeTV = ContentSizedTableView(frame: .zero)
        .then {
            $0.isScrollEnabled = false
            $0.separatorStyle = .singleLine
            $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.backgroundColor = .white
            $0.rowHeight = CGFloat(MyRecordDetailVC.challengeListCellHeight)
        }

    static let challengeListCellHeight = 69
    private let subTitleLabelHeight = 52
    private let separatorHeight = 2
    
    private let naviBar = NavigationBar()
    private let viewModel = MyRecordDetailVM()
    private let bag = DisposeBag()
    var recordID: Int?
    var matrices: [Matrix]?

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
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindRecordData()
        bindTableView()
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
                                 memoView,
                                 challengeListView])
        recordBaseView.addSubviews([recordDate,
                                    recordTime,
                                    blocksCntView,
                                    miniMap.view,
                                    recordStackView])
        memoView.addSubviews([memoLabel,
                              memoEditBtn,
                              viewSeparator,
                              noneMemoLabel,
                              memoTextView])
        challengeListView.addSubviews([challengeViewTitle,
                                       viewSeparator2,
                                       proceedingChallengeTV])
    }
    
    private func configureChallengeListTV() {
        proceedingChallengeTV.register(ProceedingChallengeTVC.self,
                                       forCellReuseIdentifier: ProceedingChallengeTVC.className)
    }
    
    private func configureRecordValue(recordData: DetailRecordDataResponseModel) {
        recordDate.text = recordData.date
        recordTime.text = recordData.started + "-" + recordData.ended
        blocksCntView.recordValue.text = "\(recordData.matrixNumber)"
        miniMap.drawMyMapAtOnce(matrices: recordData.matrices)
        recordStackView.firstView.recordValue.text = "\(recordData.distance.toKilometer)"
        recordStackView.secondView.recordValue.text = recordData.exerciseTime
        recordStackView.thirdView.recordValue.text = "\(recordData.stepCount)".insertComma
        memoTextView.isHidden = recordData.message == ""
        memoTextView.tv.text = recordData.message
        matrices = recordData.matrices
    }
}

// MARK: - Layout

extension MyRecordDetailVC {
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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
            $0.leading.trailing.equalToSuperview()
        }
        
        challengeListView.snp.makeConstraints {
            $0.top.equalTo(memoView.snp.bottom)
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
            $0.height.equalTo(subTitleLabelHeight)
        }
        
        memoEditBtn.snp.makeConstraints {
            $0.centerY.equalTo(memoLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.width.equalTo(24)
        }
        
        viewSeparator.snp.makeConstraints {
            $0.top.equalTo(memoLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(separatorHeight)
        }
        
        noneMemoLabel.snp.makeConstraints {
            $0.top.equalTo(viewSeparator.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(viewSeparator.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        challengeViewTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(subTitleLabelHeight)
        }
        
        viewSeparator2.snp.makeConstraints {
            $0.top.equalTo(challengeViewTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(separatorHeight)
        }
        
        proceedingChallengeTV.snp.makeConstraints {
            $0.top.equalTo(viewSeparator2.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension MyRecordDetailVC {
    private func bindBtn() {
        memoEditBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let recordId = self.recordID else { return }
                let editRecordMomoVC = EditRecordMemoVC()
                editRecordMomoVC.delegate = self
                editRecordMomoVC.getRecordData(recordId: recordId,
                                               memo: self.memoTextView.tv.text)
                self.navigationController?.pushViewController(editRecordMomoVC, animated: true)
            })
            .disposed(by: bag)
    
        miniMap.magnificationBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let matrices = self.matrices else { return }
                let detailMapVC = MyDetailMapVC()
                detailMapVC.matrices = matrices
                self.navigationController?.pushViewController(detailMapVC, animated: true)
            })
            .disposed(by: bag)
    }
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
    
    private func bindTableView() {
        viewModel.output.dataSource
            .bind(to: proceedingChallengeTV.rx.items(dataSource: tableViewDataSource()))
            .disposed(by: bag)
        
        viewModel.output.challengeList
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.proceedingChallengeTV.reloadData()
            })
            .disposed(by: bag)
        
        proceedingChallengeTV.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self,
                      let cell = self.proceedingChallengeTV.cellForRow(at: indexPath) as? ProceedingChallengeTVC,
                      let uuid = cell.challengeUUID
                else { return }
                // deselect
                self.proceedingChallengeTV.deselectRow(at: indexPath, animated: true)
                
                // 챌린지 종료 확인
                let isChallengeOver = (cell.endDate != nil) ? (cell.endDate?.compare(.now) == ComparisonResult.orderedAscending) : true
                
                // 챌린지 상세 화면 연결
                let challengeDetailVC = ChallengeHistoryDetailVC()
                if isChallengeOver { challengeDetailVC.configureChallengeDoneLayout() }
                challengeDetailVC.getChallengeHistoryDetailInfo(uuid: uuid)
                challengeDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(challengeDetailVC, animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - DataSource

extension MyRecordDetailVC {
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<ProceedingChallengeDataSource> {
        RxTableViewSectionedReloadDataSource<ProceedingChallengeDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ProceedingChallengeTVC.className,
                    for: indexPath
                ) as? ProceedingChallengeTVC else {
                    fatalError()
                }
                
                cell.configureCell(with: item)
                
                return cell
            })
    }
}

// MARK: - RecordMemoChanged Protocol

extension MyRecordDetailVC: RecordMemoChanged {
    func popupToastView() {
        popupToast(toastType: .saveCompleted)
    }
}
