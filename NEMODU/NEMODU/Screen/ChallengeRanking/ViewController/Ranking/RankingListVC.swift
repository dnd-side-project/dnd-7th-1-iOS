//
//  RankingListVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/10/17.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class RankingListVC : BaseViewController {
    
    // MARK: - UI components
    
    let weeksNavigationView = UIView()
    private lazy var previousWeekButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray900
        }
    private let weeksNavigationLabel = UILabel()
        .then {
            $0.text = "----.-- -주차"
            $0.font = .boldSystemFont(ofSize: 18)
            $0.textColor = .gray900
        }
    private lazy var nextWeekButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .gray900
        }
    
    let myRankingTVC = RankingUserTVC()
    
    private let rankingHeaderBorderLineView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }
    
    private let rankingTableView = UITableView(frame: .zero, style: .grouped)
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            
            // footerView 하단 여백이 생기는 것을 방지(tableView 내의 scrollView의 inset 값 때문인 것으로 추정)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        }
        
    // MARK: - Variables and Properties
    
//    var reloadRankingTypeIndex = 0
    
    private var selectedDate: Date = .now
    
//    let viewModel = ChallengeRankingVM()
    private let bag = DisposeBag()
    
//    var areaRankings: AreaRankingListResponseModel?
//    var stepRankings: StepRankingListResponseModel?
//    var accumulateRankings: AccumulateRankingListResponseModel?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
        configureWeeksNavigation(targetDate: 0)
        configureRankingUserTVC()
        configureTableView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configreLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    // MARK: - Functions
    
    func configureRankingUserTVC() {
        myRankingTVC.markMyRankingTVC(rankNumber: 5, blocksNumber: 1)
    }
    
}

// MARK: - Configure

extension RankingListVC {
    
    private func configureWeeksNavigation(targetDate: Int) {
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
    
    private func configureTableView() {
        _ = rankingTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(RankingUserTVC.self, forCellReuseIdentifier: RankingUserTVC.className)
//                $0.register(NoListStatusTVFV.self, forHeaderFooterViewReuseIdentifier: NoListStatusTVFV.className)
            }
    }
    
}

// MARK: - Layout

extension RankingListVC {
    
    private func configreLayout() {
        view.addSubviews([
                                 weeksNavigationView,
                                 myRankingTVC,
                                 rankingHeaderBorderLineView,
                                 rankingTableView])
        weeksNavigationView.addSubviews([previousWeekButton, weeksNavigationLabel, nextWeekButton])
        
        
        weeksNavigationView.snp.makeConstraints {
            $0.height.equalTo(60)
            
            $0.top.horizontalEdges.equalTo(view)
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
            $0.horizontalEdges.equalTo(view)
        }
        rankingHeaderBorderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.top.equalTo(myRankingTVC.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(view)
        }
        rankingTableView.snp.makeConstraints {
            $0.top.equalTo(rankingHeaderBorderLineView.snp.bottom)
            $0.horizontalEdges.equalTo(view)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
}

// MARK: - TableView DataSource

extension RankingListVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC
        else { return UITableViewCell() }
        
        let ranking = indexPath.row + 1
        
        cell.configureCell(ranking: ranking)
        
        switch ranking {
        case 1,2,3:
            cell.markTop123(isOn: true)
        case 5:
            cell.markMyRanking(isOn: true)
        default:
            break
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoListStatusTVFV.className) as? NoListStatusTVFV
        footerView?.statusLabel.text = "랭킹 목록이 없습니다."

        return footerView
    }

}

// MARK: - TableView Delegate

extension RankingListVC : UITableViewDelegate {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let fakeView = UIView()
            fakeView.backgroundColor = .white

            return fakeView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    // FooterView
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
}

// MARK: - Input

extension RankingListVC {
    
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


// MARK: - Output

extension RankingListVC {
    
}
