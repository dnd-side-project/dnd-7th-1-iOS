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
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor.black
        }
    
    private let noneMessage = UILabel()
        .then {
            $0.text = "지금 진행중인 챌린지가 없습니다.\n친구들과 일주일 챌린지, 실시간 챌린지를 할 수 있어요!"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor.lightGray
            $0.setLineBreakMode()
            $0.textAlignment = .center
        }
    
    private let makeChallengeBtn = UIButton()
        .then {
            $0.setTitle("챌린지 만들러가기", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            $0.backgroundColor = UIColor.systemGray5
            $0.layer.cornerRadius = 22
        }
    
    private let proceedingChallengeTV = UITableView(frame: .zero)
        .then {
            $0.isScrollEnabled = false
            $0.separatorStyle = .singleLine
            $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    
    var challengeCnt: Int?
    
    override func configureView() {
        super.configureView()
        configureBottomSheet()
    }
}

// MARK: - Layout

extension ChallengeListBottomSheet {
    func configureBottomSheet() {
        contentView.addSubviews([viewBar,
                                 sheetTitle])
        
        // bottomSheet height
        contentView.snp.makeConstraints {
            $0.height.equalTo(270)
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
        
        challengeCnt == 0 || challengeCnt == nil
        ? configureNoneData() : configureChallengeListTV()
    }
    
    func configureChallengeListTV() {
        contentView.addSubview(proceedingChallengeTV)
        
        proceedingChallengeTV.register(ProceedingChallengeTVC.self,
                                       forCellReuseIdentifier: ProceedingChallengeTVC.className)
        proceedingChallengeTV.dataSource = self
        proceedingChallengeTV.delegate = self
        
        proceedingChallengeTV.snp.makeConstraints {
            $0.top.equalTo(sheetTitle.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureNoneData() {
        contentView.addSubviews([noneMessage,
                                 makeChallengeBtn])
        
        noneMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sheetTitle.snp.bottom).offset(58)
        }
        
        makeChallengeBtn.snp.makeConstraints {
            $0.top.equalTo(noneMessage.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-32)
            $0.height.equalTo(44)
        }
    }
}

// MARK: - UITableViewDataSource
extension ChallengeListBottomSheet: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        challengeCnt ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProceedingChallengeTVC.className, for: indexPath)
                as? ProceedingChallengeTVC else { fatalError() }
        cell.configureCell()
        return cell
    }
    
    // TODO: - 서버 연결 후 dataSource 수정
//    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<ProceedingChallengeDataSource> {
//        RxTableViewSectionedReloadDataSource<ProceedingChallengeDataSource>(
//            configureCell: { dataSource, tableView, indexPath, item in
//                guard let cell = tableView.dequeueReusableCell(
//                    withIdentifier: ProceedingChallengeTVC.className,
//                    for: indexPath
//                ) as? ProceedingChallengeTVC else {
//                    fatalError()
//                }
//                // 등록
//                cell.configureCell()
//
//                return cell
//            })
//    }
}

// MARK: - UITableViewDelegate

extension ChallengeListBottomSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        61.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}