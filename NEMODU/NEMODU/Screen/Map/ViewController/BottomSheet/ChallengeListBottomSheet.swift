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

class ChallengeListBottomSheet: DynamicBottomSheetViewController {
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
        }
    
    private let viewModel = ChallengeListVM()
    private let bag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProceedingChallengeList()
    }
    
    override func configureView() {
        super.configureView()
        configureBottomSheet()
        bindTableView()
    }
}

// MARK: - Layout

extension ChallengeListBottomSheet {
    private func configureBottomSheet() {
        contentView.addSubviews([viewBar,
                                 sheetTitle])
        
        // bottomSheet height
        contentView.snp.makeConstraints {
            $0.height.equalTo(304)
        }
        
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
    
    private func configureChallengeListTV() {
        contentView.addSubview(proceedingChallengeTV)
        
        proceedingChallengeTV.register(ProceedingChallengeTVC.self,
                                       forCellReuseIdentifier: ProceedingChallengeTVC.className)
        proceedingChallengeTV.delegate = self
        
        proceedingChallengeTV.snp.makeConstraints {
            $0.top.equalTo(sheetTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureNoneData() {
        contentView.addSubviews([noneMessage,
                                 makeChallengeBtn])
        
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

// MARK: - Output
extension ChallengeListBottomSheet {
    func bindTableView() {
        viewModel.output.dataSource
            .bind(to: proceedingChallengeTV.rx.items(dataSource: tableViewDataSource()))
            .disposed(by: bag)
        
        viewModel.output.challengeList
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                item.count == 0
                ? owner.configureNoneData()
                : owner.configureChallengeListTV()
                owner.proceedingChallengeTV.reloadData()
            })
            .disposed(by: bag)
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

// MARK: - UITableViewDelegate

extension ChallengeListBottomSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        69.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
