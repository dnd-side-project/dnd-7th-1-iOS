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
    
    private let proceedingChallengeTV = UITableView(frame: .zero)
        .then {
            $0.isScrollEnabled = false
            $0.separatorStyle = .singleLine
            $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.backgroundColor = .white
        }

    private let challengeListCellHeight = 69
    private let subTitleLabelHeight = 52
    private let separatorHeight = 2
    
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
        proceedingChallengeTV.delegate = self
    }
    
    private func configureRecordValue(recordData: DetailRecordDataResponseModel) {
        recordDate.text = recordData.date
        recordTime.text = recordData.started + "-" + recordData.ended
        blocksCntView.recordValue.text = "\(recordData.matrixNumber)"
        miniMap.blocks = recordData.matrices
        miniMap.drawMiniMap()
        recordStackView.firstView.recordValue.text = "\(recordData.distance.toKilometer)"
        recordStackView.secondView.recordValue.text = recordData.exerciseTime
        recordStackView.thirdView.recordValue.text = "\(recordData.stepCount)".insertComma
        memoTextView.isHidden = recordData.message == ""
        memoTextView.tv.text = recordData.message
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
    
    private func setChallengeListViewHeight(cnt: Int) {
        challengeListView.isHidden = cnt == 0
        let titleHeight = cnt == 0 ? 0 : subTitleLabelHeight + separatorHeight
        
        challengeListView.snp.makeConstraints {
            $0.height.equalTo(titleHeight + cnt * challengeListCellHeight)
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
                editRecordMomoVC.getRecordData(recordId: recordId,
                                               memo: self.memoTextView.tv.text)
                self.navigationController?.pushViewController(editRecordMomoVC, animated: true)
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
                if item.count == 0 { return }
                owner.proceedingChallengeTV.reloadData()
                owner.setChallengeListViewHeight(cnt: item.count)
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

// MARK: - UITableViewDelegate

extension MyRecordDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(challengeListCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
