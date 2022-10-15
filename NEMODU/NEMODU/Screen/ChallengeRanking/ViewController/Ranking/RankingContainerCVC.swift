//
//  RankingContainerCVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/05.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class RankingContainerCVC : BaseCollectionViewCell {
    
    // MARK: - UI components
    
    let rankingListTypeMenuBar = RankingListTypeMenuBarCV()
        .then {
            $0.menuList = ["영역 랭킹", "걸음수 랭킹", "역대 누적 랭킹"]
            $0.menuBarCollectionView.backgroundColor = .yellow
        }
    
    let weeksNavigationView = UIView()
    
    lazy var previousWeekButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray900            
        }
    let weeksNavigationLabel = UILabel()
        .then {
            $0.text = "----.-- -주차"
            $0.font = .boldSystemFont(ofSize: 18)
            $0.textColor = .gray900
        }
    lazy var nextWeekButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray900
        }
    
    let myRankingTVC = RankingUserTVC()
        .then {
            $0.markMyRankingCell()
        }
    let rankingHeaderBorderLineView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }
    
    let rankingTableView = UITableView(frame: .zero, style: .grouped)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            
            // footerView 하단 여백이 생기는 것을 방지(tableView 내의 scrollView의 inset 값 때문인 것으로 추정)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        }
        
    // MARK: - Variables and Properties
    
    var reloadRankingTypeIndex = 0
    
    var selectedDate: Date = .now
    
    let viewModel = ChallengeRankingVM()
    private let bag = DisposeBag()
    
    var areaRankings: AreaRankingListResponseModel?
    var stepRankings: StepRankingListResponseModel?
    var accumulateRankings: AccumulateRankingListResponseModel?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let userNickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
//        viewModel.getAreaRankingList(with: RankingListRequestModel(end: "2022-08-18T23:59:59",
//                                                                       nickname: userNickname,
//                                                                       start: "2022-08-15T00:00:00"))
        
        bindButton()
        
        bindAreaRankingTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    override func configureView() {
        super.configureView()
        
        rankingListTypeMenuBar.rankingContainerCVC = self
        
        configureWeeksNavigation(targetDate: 0)
        
        _ = rankingTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(RankingUserTVC.self, forCellReuseIdentifier: RankingUserTVC.className)
                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
            }
    }
    
    override func layoutView() {
        super.layoutView()
        
        contentView.addSubviews([rankingListTypeMenuBar,
                                 weeksNavigationView,
                                 myRankingTVC,
                                 rankingHeaderBorderLineView,
                                 rankingTableView])
        weeksNavigationView.addSubviews([previousWeekButton, weeksNavigationLabel, nextWeekButton])
        
        
        rankingListTypeMenuBar.snp.makeConstraints {
            $0.height.equalTo(64)

            $0.top.equalTo(contentView.snp.top)
            $0.horizontalEdges.equalTo(contentView)
        }
        
        weeksNavigationView.snp.makeConstraints {
            $0.height.equalTo(60)
            
            $0.top.equalTo(rankingListTypeMenuBar.snp.bottom)
            $0.horizontalEdges.equalTo(rankingListTypeMenuBar)
            
        }
        previousWeekButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(previousWeekButton.snp.width)
            
            $0.centerY.equalTo(weeksNavigationLabel)
            $0.right.equalTo(weeksNavigationLabel.snp.left).inset(-24)
        }
        weeksNavigationLabel.snp.makeConstraints {
            $0.center.equalTo(weeksNavigationView)
        }
        nextWeekButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(nextWeekButton.snp.width)
            
            $0.centerY.equalTo(weeksNavigationLabel)
            $0.left.equalTo(weeksNavigationLabel.snp.right).offset(24)
        }
        
        myRankingTVC.snp.makeConstraints {
            $0.height.equalTo(84)
            
            $0.top.equalTo(weeksNavigationView.snp.bottom)
            $0.horizontalEdges.equalTo(contentView)
        }
        rankingHeaderBorderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.top.equalTo(myRankingTVC.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(contentView)
        }
        rankingTableView.snp.makeConstraints {
            $0.top.equalTo(rankingHeaderBorderLineView.snp.bottom)
            $0.horizontalEdges.equalTo(contentView)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func configureWeeksNavigation(targetDate: Int) {
        var calendar = Calendar(identifier: .gregorian)
        // 일...토까지 1...7로 번호 구성
        calendar.firstWeekday = 2 // 주의 시작요일을 월요일로 지정
        
        let week = DateComponents(day: targetDate)
        selectedDate = calendar.date(byAdding: week, to: selectedDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        let weekOfMonth = calendar.component(.weekOfMonth, from: selectedDate)
        weeksNavigationLabel.text = "\(dateFormatter.string(from: selectedDate)) \(weekOfMonth)주차"
        
        let active = Calendar.current.compare(.now, to: selectedDate, toGranularity: .weekOfYear) == .orderedSame ? false : true
        nextWeekButton.isUserInteractionEnabled = active
        nextWeekButton.tintColor = active ? .gray900 : .gray300
    }
    
}

// MARK: - RankingTableView Delegate

extension RankingContainerCVC : UITableViewDelegate { }

// MARK: - RankingTableView DataSource

extension RankingContainerCVC : UITableViewDataSource {

    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if reloadRankingTypeIndex != 2 && section == 0 {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RankingWeeksNavigationTVHV.className) as? RankingWeeksNavigationTVHV
//            headerView?.rankingContainerCVC = self
//
//            return headerView
//        } else {
            let fakeView = UIView()
            fakeView.backgroundColor = .white

            return fakeView
//        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        24
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        24
    }

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 1 {
//            switch reloadRankingTypeIndex {
//            case 0:
//                return areaRankings?.areaRankings.count ?? 0
//            case 1:
//                return stepRankings?.stepRankings.count ?? 0
//            case 2:
//                return accumulateRankings?.matrixRankings.count ?? 0
//            default:
//                return 0
//            }
//        } else {
//            return 0
//        }
        
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC else {
            return UITableViewCell()
        }
        
//        if indexPath.section == 1 {
//
//            // 영역 타입별 테이블 셀 설정
//            switch reloadRankingTypeIndex {
//            case 0:
//                guard let areaRanking = areaRankings else { return cell }
//                cell.configureAreaRankingCell(with: areaRanking.areaRankings[indexPath.row])
//            case 1:
//                guard let stepRanking = stepRankings else { return cell }
//                cell.configureStepRankingCell(with: stepRanking.stepRankings[indexPath.row])
//            case 2:
//                guard let accumulateRanking = accumulateRankings else { return cell }
//                cell.configureAccumulateRankingCell(with: accumulateRanking.matrixRankings[indexPath.row])
//            default:
//                break
//            }
//
//
//            // 걸음수 랭킹 설정
//            if reloadRankingTypeIndex == 1 {
//                cell.blockLabel.text = "걸음"
//            }
//
//            // 칸 혹은 걸음 콤마 설정
//            cell.blocksNumberLabel.insertComma()
//
//            // 내 기록 표시 설정
//            let myNickname = "NickD" // 임시지정
//            if cell.userNicknameLabel.text == myNickname {
//                cell.markMyRankingCell()
//            }
//
//            // 1, 2, 3등 표시 설정
//            let ranking = Int(cell.rankNumberLabel.text ?? "0")
//            switch ranking {
//            case 1, 2, 3:
//                cell.rankNumberLabel.textColor = .main
//            default:
//                break
//            }
//
//        }
        
        cell.rankNumberLabel.text = String(indexPath.row)
        cell.userNicknameLabel.text = "Hi there"
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("rankingTV row selected ", indexPath.row)
    }

    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV
        footerView?.statusLabel.text = "랭킹 목록이 없습니다."

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = .leastNormalMagnitude

//        if section == 1 {
//            switch reloadRankingTypeIndex {
//            case 0:
//                if areaRankings?.areaRankings.count == 0 {
//                    height = 93
//                }
//            case 1:
//                if stepRankings?.stepRankings.count == 0 {
//                    height = 93
//                }
//            case 2:
//                if accumulateRankings?.matrixRankings.count == 0 {
                    height = 93
//                }
//            default:
//                break
//            }
//        }

        return height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }

}

// MARK: - bind

extension RankingContainerCVC {
    
    func bindAreaRankingTableView() {
        viewModel.output.areaRankings
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.areaRankings = data
                self.rankingTableView.reloadData()
            })
            .disposed(by: bag)
    }
    
    func bindStepRankingTableView() {
        viewModel.output.stepRankings
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.stepRankings = data
                self.rankingTableView.reloadSections(IndexSet(1...1), with: .fade)
            })
            .disposed(by: bag)
    }
    
    func bindAccumulateRankingTableView() {
        viewModel.output.accumulateRankings
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.accumulateRankings = data
                self.rankingTableView.reloadSections(IndexSet(1...1), with: .fade)
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Input

extension RankingContainerCVC {
    private func bindButton() {
        previousWeekButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.configureWeeksNavigation(targetDate: -7)
            })
            .disposed(by: bag)
        
        nextWeekButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.configureWeeksNavigation(targetDate: 7)
            })
            .disposed(by: bag)
    }
    
}
