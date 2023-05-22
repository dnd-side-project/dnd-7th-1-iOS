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
    var uuid: String?
    var latitude: Double?
    var longitude: Double?
    
    private let viewModel = ChallengeDetailMapVM()
    private let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let uuid = uuid,
              let location = mapVC.locationManager.location
        else { return }
        viewModel.getChallengeDetailMap(uuid: uuid,
                                        latitude: latitude ?? location.coordinate.latitude,
                                        longitude: longitude ?? location.coordinate.longitude)
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
        bindMapGesture()
        bindSelectUserRankingListTV()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindAnnotations()
        bindMatrices()
        bindRank()
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
        
        // TODO: - 지도 구조 변경
        mapVC.mapView.layer.cornerRadius = 0
        mapVC.isUserInteractionEnabled(true)
        
        if let latitude = latitude,
           let longitude = longitude {
            _ = mapVC.goLocation(latitudeValue: latitude,
                                 longitudeValue: longitude,
                                 delta: Map.defaultZoomScale)
        }
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

// MARK: - Input

extension ChallengeDetailMapVC {
    /// 지도 제스쳐에 맞춰 현재 보이는 화면의 영역을 받아오는 메서드
    private func bindMapGesture() {
        mapVC.mapView.rx.anyGesture(.pan(), .pinch())
            .when(.ended)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let uuid = self.uuid else { return }
                self.viewModel.getUpdateBlocks(uuid,
                                               self.mapVC.mapView.region.center.latitude,
                                               self.mapVC.mapView.region.center.longitude,
                                               self.mapVC.mapView.region.span.latitudeDelta)
            })
            .disposed(by: bag)
    }
    
    /// 유저 선택 시 해당 유저의 마지막 위치로 이동하는 메서드
    private func bindSelectUserRankingListTV() {
        userRankingListTV.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self,
                      let cell = self.userRankingListTV.cellForRow(at: indexPath) as? ChallengeDetailMapRankingTVC,
                      let uuid = self.uuid
                else { return }
                guard let location = cell.getLocation(),
                      let latitude = location.latitude,
                      let longitude = location.longitude
                else {
                    self.popupToast(toastType: .noRecord)
                    return
                }
                self.viewModel.getUpdateBlocks(uuid,
                                               latitude,
                                               longitude,
                                               self.mapVC.mapView.region.span.latitudeDelta)
                
                _ = self.mapVC.goLocation(latitudeValue: latitude,
                                          longitudeValue: longitude,
                                          delta: Map.defaultZoomScale)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension ChallengeDetailMapVC {
    private func bindAnnotations() {
        viewModel.output.userLastLocation
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)
                else { return }
                for user in data {
                    if let latitude = user.latitude,
                       let longitude = user.longitude {
                        
                        user.nickname == nickname
                        ? self.mapVC.addMyAnnotation(coordinate: Matrix(latitude: latitude,
                                                                        longitude: longitude),
                                                     profileImageURL: user.picturePathURL)
                        : self.mapVC.addFriendAnnotation(coordinate: Matrix(latitude: latitude,
                                                                            longitude: longitude),
                                                         profileImageURL: user.picturePathURL,
                                                         nickname: user.nickname,
                                                         color: ChallengeColorType(rawValue: user.color)?.primaryColor ?? .main,
                                                         isBorderOn: true)
                    }
                }
            })
            .disposed(by: bag)
    }
    
    private func bindMatrices() {
        viewModel.output.matrices
            .subscribe(onNext: { [weak self] nickname, matrices in
                guard let self = self,
                      let myNickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname),
                      let blockColor = self.viewModel.input.userTable[nickname] else { return }
                let owner: BlocksType = nickname == myNickname ? .mine : .friends
                self.mapVC.drawBlockArea(matrices: matrices,
                                         owner: owner,
                                         blockColor: ChallengeColorType(rawValue: blockColor.color)?.blockColor ?? .clear)
            })
            .disposed(by: bag)
    }
    
    private func bindRank() {
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
