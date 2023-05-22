//
//  ChallengeListBottomSheet.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/08.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import DynamicBottomSheet

class ChallengeListBottomSheet: DynamicBottomSheetViewController, APIErrorHandling {
    private let viewBar = UIView()
        .then {
            $0.backgroundColor = UIColor.systemGray4
            $0.layer.cornerRadius = 2
        }
    
    private let sheetTitle = UILabel()
        .then {
            $0.text = "진행중인 챌린지"
            $0.font = .body2
            $0.textColor = .gray900
        }
    
    private let noneMessage = UILabel()
        .then {
            $0.text = "지금 진행중인 챌린지가 없습니다.\n친구들과 일주일 챌린지, 실시간 챌린지를 할 수 있어요!"
            $0.font = .caption1
            $0.textColor = .gray500
            $0.setLineBreakMode()
            $0.textAlignment = .center
        }
    
    private let makeChallengeBtn = UIButton()
        .then {
            $0.setTitle("챌린지 만들러가기", for: .normal)
            $0.setTitleColor(.gray900, for: .normal)
            $0.titleLabel?.font = .headline1
            $0.backgroundColor = .gray200
            $0.layer.cornerRadius = 22
        }
    
    private let proceedingChallengeTV = UITableView(frame: .zero)
        .then {
            $0.isScrollEnabled = false
            $0.separatorStyle = .singleLine
            $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.backgroundColor = .white
            $0.rowHeight = CGFloat(ChallengeListBottomSheet.cellHeight)
        }
    
    private let viewModel = ChallengeListVM()
    let disposeBag = DisposeBag()
    weak var delegate: PushChallengeVC?
    
    // constants
    static let cellHeight = 69
    private let emptyViewHeight = 304
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProceedingChallengeList()
    }
    
    override func configureView() {
        super.configureView()
        configureBottomSheet()
        bindTableView()
        bindMakeChallengeBtn()
        bindAPIErrorAlert(viewModel)
    }
}

// MARK: - Layout

extension ChallengeListBottomSheet {
    private func configureBottomSheet() {
        contentView.addSubviews([viewBar,
                                 sheetTitle])
        
        viewBar.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        sheetTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(viewBar.snp.bottom).offset(8)
        }
    }
    
    /// 챌린지 개수에 따라 화면 구현
    private func configureChallengeListTV(_ challengeCnt: Int) {
        contentView.addSubview(proceedingChallengeTV)
        
        proceedingChallengeTV.register(ProceedingChallengeTVC.self,
                                       forCellReuseIdentifier: ProceedingChallengeTVC.className)
        
        // Layout
        contentView.snp.updateConstraints {
            $0.height.equalTo(challengeCnt * ChallengeListBottomSheet.cellHeight + 55 + Int(UIApplication.shared.window?.safeAreaInsets.bottom ?? 0))
        }
        
        proceedingChallengeTV.snp.makeConstraints {
            $0.top.equalTo(sheetTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    /// 챌린지가 존재하지 않을 때의 화면
    private func configureNoneData() {
        contentView.addSubviews([noneMessage,
                                 makeChallengeBtn])
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(emptyViewHeight)
        }
        
        noneMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sheetTitle.snp.bottom).offset(72)
        }
        
        makeChallengeBtn.snp.makeConstraints {
            $0.top.equalTo(noneMessage.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-32)
            $0.height.equalTo(44)
        }
    }
}

// MARK: - Input
extension ChallengeListBottomSheet {
    func bindMakeChallengeBtn() {
        makeChallengeBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.delegate?.pushCreateChallengeVC()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output
extension ChallengeListBottomSheet {
    func bindTableView() {
        viewModel.output.dataSource
            .bind(to: proceedingChallengeTV.rx.items(dataSource: tableViewDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.output.challengeList
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                item.count == 0
                ? owner.configureNoneData()
                : owner.configureChallengeListTV(item.count)
                owner.proceedingChallengeTV.reloadData()
            })
            .disposed(by: disposeBag)
        
        proceedingChallengeTV.rx.itemSelected
            .asDriver()
            .drive(onNext: {[weak self] indexPath in
                guard let self = self,
                      let cell = self.proceedingChallengeTV.cellForRow(at: indexPath) as? ProceedingChallengeTVC,
                      let uuid = cell.challengeUUID
                else { return }
                self.proceedingChallengeTV.deselectRow(at: indexPath, animated: true)
                self.dismiss(animated: true) {
                    self.delegate?.pushChallengeDetail(uuid)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource
extension ChallengeListBottomSheet {
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<ProceedingChallengeDataSource> {
        RxTableViewSectionedReloadDataSource<ProceedingChallengeDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ProceedingChallengeTVC.className,
                    for: indexPath
                ) as? ProceedingChallengeTVC else {
                    fatalError()
                }
                // 등록
                cell.configureCell(with: item, isMyList: true)
                
                return cell
            })
    }
}

// MARK: - Protocol

protocol PushChallengeVC: AnyObject {
    func pushCreateChallengeVC()
    
    func pushChallengeDetail(_ uuid: String)
}
