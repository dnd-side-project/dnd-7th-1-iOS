//
//  ChallengeDetailMapVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/18.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class ChallengeDetailMapVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let mapVC = MiniMapVC()
        .then {
            $0.hideMagnificationBtn()
        }
    
    private let userRankingListTV = ContentSizedTableView(frame: .zero)
        .then {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.rowHeight = 52
            $0.separatorStyle = .none
        }
    
    var challengeTitle: String?
    
    private let viewModel = ChallengeDetailMapVM()
    private let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNavigationBar()
        configureContentView()
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
        bindUserData()
    }
    
    override func bindLoading() {
        super.bindLoading()
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.loading(loading: isLoading)
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Configure

extension ChallengeDetailMapVC {
    private func configureNavigationBar() {
        naviBar.naviType = .push
        naviBar.backgroundColor = .white
        naviBar.configureBackBtn(targetVC: self)
        naviBar.configureNaviBar(targetVC: self, title: challengeTitle)
    }
    
    private func configureContentView() {
        addChild(mapVC)
        view.addSubviews([mapVC.view,
                          userRankingListTV])
        userRankingListTV.register(ChallengeDetailMapRankingTVC.self,
                                   forCellReuseIdentifier: ChallengeDetailMapRankingTVC.className)
        
        userRankingListTV.dataSource = self
    }
    
    func getChallengeDetailMap(uuid: String) {
        let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""
        viewModel.getChallengeDetailMap(nickname: nickname, uuid: uuid)
    }
}

// MARK: - Layout

extension ChallengeDetailMapVC {
    private func configureLayout() {
        mapVC.view.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        userRankingListTV.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-22)
        }
    }
}

// MARK: - Output

extension ChallengeDetailMapVC {
    
    private func bindUserData() {
        viewModel.output.userMatrixData
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
            })
            .disposed(by: bag)
        
        viewModel.output.usersRankData
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.userRankingListTV.reloadData()
            })
            .disposed(by: bag)
    }
    
}

// MARK: - UITableViewDataSource

extension ChallengeDetailMapVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.usersRankData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeDetailMapRankingTVC.className,
                                                       for: indexPath) as? ChallengeDetailMapRankingTVC
        else { return UITableViewCell() }
        let nickname = viewModel.output.usersRankData.value[indexPath.row].nickname
        
        guard let user = viewModel.input.userTable[nickname] else { return cell }
        cell.configureCell(rank: viewModel.output.usersRankData.value[indexPath.row],
                           matrix: user)
        return cell
    }
}
