//
//  ChallengeHistoryDetailVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/11/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ChallengeHistoryDetailVC: ChallengeDetailVC {
    
    // MARK: - UI components
    
    let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }
    
    private let challengeDetailInfoView = ChallengeDetailInfoView()
    
    private let dDayTextLabel = UILabel()
        .then {
            $0.text = "D-"
            $0.textAlignment = .center
            $0.textColor = .main
            
            $0.font = UIFont(name: "Pretendard-Bold", size: 14)
            $0.backgroundColor = .main.withAlphaComponent(0.2)
            
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
    private let dDayTextTriangleView = UIView()
    
    private let progressStatusContainerView = UIView()
    private let progressBarWrapperView = UIView()
        .then {
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
    private let progressBarStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 1
            $0.alignment = .fill
            $0.distribution = .fillEqually
            
            $0.backgroundColor = .white
        }
    private let progressBlackBarStackView = UIStackView()
        .then {
            $0.backgroundColor = .black
        }
    
    private let startLabel = UILabel()
        .then {
            $0.textColor = .gray800
            $0.font = .caption1
            
            $0.text = "--.-- 부터"
        }
    private let endLabel = UILabel()
        .then {
            $0.textColor = .gray800
            $0.font = .caption1
            
            $0.text = "--.-- 까지"
        }
    
    private let guideLabel = UILabel()
        .then {
            $0.textColor = .gray800
            $0.font = .caption1
        }
    
    private let borderLineView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }
    
    private let scoreStatusContainerView = UIView()
    private let scoreTitleLabel = PaddingLabel()
        .then {
            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            $0.text = "점수 현황"
            $0.font = .body1
            $0.textColor = .gray900
            
            $0.backgroundColor = .white
        }
    private let updateStatusLabel = UILabel()
        .then {
            $0.text = "--:-- 기준"
            $0.textColor = .gray600
            $0.font = .body3
        }
    private let updateButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "update"), for: .normal)
        }
    
    private var miniMapVC = MiniMapVC()
    
    private let myRecordStatusContainerView = UIView()
    private let myRecordTitleLabel = PaddingLabel()
        .then {
            $0.text = "나의 기록"
            $0.font = .body2
            $0.textColor = .gray900
            
            $0.edgeInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    private let myRecordStackView = RecordStackView()
        .then {
            $0.firstView.recordTitle.text = "거리"
            $0.secondView.recordTitle.text = "시간"
            $0.thirdView.recordTitle.text = "걸음수"
            
            $0.firstView.recordValue.text = "-"
            $0.secondView.recordValue.text = "-"
            $0.thirdView.recordValue.text = "-"
        }
    
    // MARK: - Variables and Properties
    
    private let viewModel = ChallengeHistoryDetailVM()
    private let bag = DisposeBag()
    var challengeHistoryDetailResponseModel: ChallengeHistoryDetailResponseModel?
    
    var challgeStatus: String?
    
    let tableviewCellHeight: CGFloat = 84
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
        configureTriangleView()
        configureProgressBarStackView()
        configureAttributedTextToGuideLabel(leftDayStr: "-일 --:--")
        configureUpdateStatusLabel()
        configureTableView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindChallengeHistoryDetail()
    }
    
    // MARK: - Functions
    
    func getChallengeHistoryDetailInfo(uuid: String) {
        let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""
        viewModel.getChallengeHistoryDetail(nickname: nickname, uuid: uuid)
    }
    
}

// MARK: - Configure

extension ChallengeHistoryDetailVC {
    
    private func configureChallengeHistoryDetailVC(challengeHistoryDetailInfo: ChallengeHistoryDetailResponseModel) {   
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateType.withTime.dateFormatter
        guard let startDate: Date = dateFormatter.date(from: challengeHistoryDetailInfo.started) else { return }
        guard let endDate: Date = dateFormatter.date(from: challengeHistoryDetailInfo.ended) else { return }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        let weekOfMonth = calendar.component(.weekOfMonth, from: challengeHistoryDetailInfo.started.toDate(.hyphen))
        
        challengeDetailInfoView.weekChallengeTypeLabel.text = ChallengeType(rawValue: challengeHistoryDetailInfo.type)?.title
        challengeDetailInfoView.challengeNameImageView.tintColor = ChallengeColorType(rawValue: challengeHistoryDetailInfo.color)?.primaryColor
        challengeDetailInfoView.challengeNameLabel.text = challengeHistoryDetailInfo.name
        challengeDetailInfoView.currentStateLabel.text = "\(startDate.year) \(startDate.month)월 \(weekOfMonth)주차 (\(startDate.month).\(startDate.day)~\(endDate.month).\(endDate.day))"
        setDDayStatus()
        
        startLabel.text = "\(startDate.month).\(startDate.day) 부터"
        endLabel.text = "\(endDate.month).\(endDate.day) 까지"
        
        updateChallengeTableViewHeight(rankingsCnt: challengeHistoryDetailInfo.rankings.count)
        
        _ = myRecordStackView
            .then {
                $0.firstView.recordValue.text = "\(challengeHistoryDetailInfo.distance.toKilometer)"
                $0.secondView.recordValue.text = "\(challengeHistoryDetailInfo.exerciseTime / 60):" + String(format: "%02d", challengeHistoryDetailInfo.exerciseTime % 60)
                $0.thirdView.recordValue.text = "\(challengeHistoryDetailInfo.stepCount.insertComma)"
            }
    }
    
    private func setDDayStatus() {
        let calendar = Calendar(identifier: .gregorian)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = DateType.withTime.dateFormatter
        
        let startDate = dateFormatter.string(from: .now)
        
        let currentDayNum = calendar.component(.weekday, from: startDate.toDate(.withTime))
        let toGoSundayNum = 8 - currentDayNum
        let sundayDate = calendar.date(byAdding: .day, value: toGoSundayNum, to: startDate.toDate(.withTime)) ?? startDate.toDate(.withTime)
        
        var endDate = sundayDate.toString(separator: .withT)
        endDate.append("23:59:59")
        
        dDayTextLabel.text = "D-\(toGoSundayNum)"
        progressBlackBarStackView.snp.makeConstraints {
            let bar = (progressBarStackView.frame.size.width - 6.0) / 7
            let pastDay = 7 - toGoSundayNum
            let spaceBetweenBar = pastDay == 7 ? 0 : pastDay-1;
            let length = (Int(bar) * pastDay) + (1 * spaceBetweenBar)
            
            $0.width.equalTo(length)
        }
        
        let leftDay = calendar.dateComponents([.day, .hour, .minute], from: startDate.toDate(.withTime), to: endDate.toDate(.withTime))
        let leftDayStr = "\(leftDay.day ?? 0)일 \(String(format: "%02d", leftDay.hour ?? 0)):\(String(format: "%02d", leftDay.minute ?? 0))"
        configureAttributedTextToGuideLabel(leftDayStr: leftDayStr)
    }
    
    private func configureTriangleView() {
        let path = CGMutablePath()
        
        let width: CGFloat = 13
        let height: CGFloat = 6.7
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.main.withAlphaComponent(0.2).cgColor
        
        dDayTextTriangleView.layer.insertSublayer(shape, at: 0)
    }
    
    private func configureProgressBarStackView() {
        for _ in 1...7 {
            let view = UIView()
            view.backgroundColor = .gray200
            progressBarStackView.addArrangedSubview(view)
        }
    }
    
    private func configureAttributedTextToGuideLabel(leftDayStr: String) {
        let attributedText = NSMutableAttributedString(string: "종료일까지 ", attributes: [NSAttributedString.Key.font: UIFont.body4,
                                                                                      NSAttributedString.Key.foregroundColor: UIColor.gray900])
        attributedText.append(NSAttributedString(string: leftDayStr, attributes: [NSAttributedString.Key.font: UIFont.caption1,
                                                                                                      NSAttributedString.Key.foregroundColor: UIColor.main]))
        attributedText.append(NSAttributedString(string: " 남았습니다!", attributes: [NSAttributedString.Key.font: UIFont.caption1,
                                                                                                      NSAttributedString.Key.foregroundColor: UIColor.gray900]))
        guideLabel.attributedText = attributedText
    }
    
    private func configureUpdateStatusLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = "HH:mm"
        
        let updateTime = dateFormatter.string(from: .now).split(separator: ":")
        updateStatusLabel.text = "\(updateTime[0]):\(updateTime[1]) 기준"
    }
    
    private func configureMyRecordStackView(distance: Int, time: Int, steps: Int) {
        _ = myRecordStackView
            .then {
                $0.firstView.recordValue.text = "\(distance.toKilometer)"
                $0.secondView.recordValue.text = "\(time / 60):" + String(format: "%02d", time % 60)
                $0.thirdView.recordValue.text = "\(steps.insertComma)"
            }
    }
    
    func configureChallengeDoneLayout() {
        progressStatusContainerView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        progressStatusContainerView.isHidden = true
        
        borderLineView.snp.updateConstraints {
            $0.height.equalTo(0).priority(.high)
        }
        
        updateButton.isHidden = true
        updateStatusLabel.isHidden = true
        
        scoreTitleLabel.text = "최종 순위"
    }
    
    private func configureTableView() {
        _ = challengeDetailTableView
            .then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(RankingUserTVC.self, forCellReuseIdentifier: RankingUserTVC.className)
                
                $0.isScrollEnabled = false
            }
    }
    
}

// MARK: - Layout

extension ChallengeHistoryDetailVC {
    
    private func configureLayout() {
        view.addSubviews([baseScrollView])
        baseScrollView.addSubviews([challengeDetailInfoView,
                                    progressStatusContainerView,
                                    borderLineView,
                                    scoreStatusContainerView,
                                    myRecordStatusContainerView])
        progressStatusContainerView.addSubviews([dDayTextLabel, dDayTextTriangleView,
                                                 progressBarWrapperView,
                                                 startLabel, endLabel,
                                                 guideLabel])
        progressBarWrapperView.addSubviews([progressBarStackView, progressBlackBarStackView])
        scoreStatusContainerView.addSubviews([scoreTitleLabel,
                                              updateStatusLabel, updateButton,
                                              miniMapVC.view])
        addChild(miniMapVC)
        myRecordStatusContainerView.addSubviews([myRecordTitleLabel, myRecordStackView])
        
        
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.left.right.bottom.equalTo(view)
        }
        
        challengeDetailInfoView.snp.makeConstraints {
            $0.width.equalTo(view.frame.width)
            
            $0.top.equalTo(baseScrollView.snp.top)
        }
        
        progressStatusContainerView.snp.makeConstraints {
            $0.width.equalTo(baseScrollView.snp.width)
            $0.height.equalTo(134).priority(.high)

            $0.top.equalTo(challengeDetailInfoView.snp.bottom)
        }
        dDayTextLabel.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(25.3)

            $0.centerX.equalTo(dDayTextTriangleView)
            $0.bottom.equalTo(dDayTextTriangleView.snp.top)
        }
        dDayTextTriangleView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(6.7)

            $0.centerX.equalTo(progressBlackBarStackView.snp.right)
            $0.bottom.equalTo(progressBarWrapperView.snp.top).inset(-8)
        }
        progressBarWrapperView.snp.makeConstraints {
            $0.height.equalTo(progressBarWrapperView.layer.cornerRadius * 2)

            $0.top.equalTo(progressStatusContainerView.snp.top).offset(64)
            $0.left.right.equalTo(progressStatusContainerView).inset(16)
        }
        progressBarStackView.snp.makeConstraints {
            $0.edges.equalTo(progressBarWrapperView)
        }
        progressBlackBarStackView.snp.makeConstraints {
            $0.top.left.bottom.equalTo(progressBarWrapperView)
        }

        startLabel.snp.makeConstraints {
            $0.top.equalTo(progressBarWrapperView.snp.bottom).offset(8).priority(.high)
            $0.left.equalTo(progressBarWrapperView.snp.left)
        }
        endLabel.snp.makeConstraints {
            $0.top.equalTo(progressBarWrapperView.snp.bottom).offset(8).priority(.high)
            $0.right.equalTo(progressBarWrapperView.snp.right)
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(startLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(progressBarWrapperView)
            $0.bottom.equalTo(progressStatusContainerView.snp.bottom).inset(16)
        }

        borderLineView.snp.makeConstraints {
            $0.width.equalTo(baseScrollView.snp.width)
            $0.height.equalTo(8).priority(.high)

            $0.top.equalTo(progressStatusContainerView.snp.bottom)
        }

        scoreStatusContainerView.snp.makeConstraints {
            $0.width.equalTo(baseScrollView.snp.width)
            
            $0.top.equalTo(borderLineView.snp.bottom)
        }
        scoreTitleLabel.snp.makeConstraints {
            $0.height.equalTo(56).priority(.high)

            $0.top.left.equalTo(scoreStatusContainerView)
        }
        updateStatusLabel.snp.makeConstraints {
            $0.centerY.equalTo(scoreTitleLabel)
            $0.left.equalTo(scoreTitleLabel.snp.right)
        }
        updateButton.snp.makeConstraints {
            $0.width.height.equalTo(24)

            $0.centerY.equalTo(updateStatusLabel)
            $0.left.equalTo(updateStatusLabel.snp.right).offset(4)
            $0.right.equalTo(scoreStatusContainerView.snp.right).inset(16)
        }
        miniMapVC.view.snp.makeConstraints {
            $0.height.equalTo(miniMapVC.view.snp.width).multipliedBy(0.76).priority(.high)

            $0.top.equalTo(scoreTitleLabel.snp.bottom)
            $0.horizontalEdges.equalTo(scoreStatusContainerView).inset(16)
            $0.bottom.equalTo(scoreStatusContainerView.snp.bottom).inset(12)
        }
        
        challengeDetailTableView.snp.remakeConstraints {
            $0.width.equalTo(baseScrollView.snp.width)
            $0.height.equalTo(tableviewCellHeight * 3)
            
            $0.top.equalTo(scoreStatusContainerView.snp.bottom)
        }
        
        myRecordStatusContainerView.snp.makeConstraints {
            $0.width.equalTo(baseScrollView.snp.width)
            
            $0.top.equalTo(challengeDetailTableView.snp.bottom)
            $0.bottom.equalTo(baseScrollView.snp.bottom)
        }
        myRecordTitleLabel.snp.makeConstraints {
            $0.height.equalTo(56).priority(.high)
            
            $0.top.horizontalEdges.equalTo(myRecordStatusContainerView)
        }
        myRecordStackView.snp.makeConstraints {
            $0.top.equalTo(myRecordTitleLabel.snp.bottom).offset(16).priority(.high)
            $0.horizontalEdges.equalTo(myRecordStatusContainerView)
            $0.bottom.equalTo(myRecordStatusContainerView.snp.bottom).inset(16)
        }
    }
    
    private func updateChallengeTableViewHeight(rankingsCnt: Int) {
        challengeDetailTableView.snp.updateConstraints {
            $0.height.equalTo(tableviewCellHeight * CGFloat(rankingsCnt))
        }
    }
    
}
// MARK: - TableView DataSource

extension ChallengeHistoryDetailVC : UITableViewDataSource {

    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeHistoryDetailResponseModel?.rankings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingUserTVC.className, for: indexPath) as? RankingUserTVC else { return UITableViewCell() }
        
        guard let challengeHistoryDetailInfo = challengeHistoryDetailResponseModel else { return cell }
        let userRankingInfo = challengeHistoryDetailInfo.rankings[indexPath.row]
        cell.configureRankingCell(rankNumber: userRankingInfo.rank, profileImageURL: userRankingInfo.picturePathURL, nickname: userRankingInfo.nickname, blocksNumber: userRankingInfo.score)
        cell.configureChallengeDetailRankingCell(nickname: userRankingInfo.nickname)
        
        return cell
    }

}

// MARK: - TableView Delegate

extension ChallengeHistoryDetailVC : UITableViewDelegate {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fakeView = UIView()
        fakeView.backgroundColor = .blue

        return fakeView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    // Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fakeView = UIView()
        fakeView.backgroundColor = .green

        return fakeView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}

// MARK: - Input

extension ChallengeHistoryDetailVC {
    private func bindButton() {
        updateButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let uuid: String = self.challengeHistoryDetailResponseModel?.uuid ?? ""
                self.getChallengeHistoryDetailInfo(uuid: uuid)
                
                self.configureUpdateStatusLabel()
            })
            .disposed(by: bag)
        
        miniMapVC.magnificationBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let challengeDetailMapVC = ChallengeDetailMapVC()
                guard let responseModel: ChallengeHistoryDetailResponseModel = self.challengeHistoryDetailResponseModel else { return print("No challengeHistoryDetailResponseModel") }
                challengeDetailMapVC.challengeTitle = responseModel.name
                challengeDetailMapVC.getChallengeDetailMap(uuid: responseModel.uuid)
                
                self.navigationController?.pushViewController(challengeDetailMapVC, animated: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension ChallengeHistoryDetailVC {
    private func bindChallengeHistoryDetail() {
        viewModel.output.challengeHistoryDetail
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.challengeHistoryDetailResponseModel = data
                
                self.challengeDetailTableView.reloadData()
                self.configureChallengeHistoryDetailVC(challengeHistoryDetailInfo: data)
                self.miniMapVC.drawMyMapAtOnce(matrices: data.matrices)
            })
            .disposed(by: bag)
    }
}
