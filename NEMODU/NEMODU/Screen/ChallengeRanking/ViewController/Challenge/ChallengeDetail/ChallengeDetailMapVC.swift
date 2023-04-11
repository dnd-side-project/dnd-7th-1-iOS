//
//  ChallengeDetailMapVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/01/20.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class ChallengeDetailMapVC: BaseViewController {
    
    // MARK: - UI components
    
    private let navigationBar = NavigationBar()
        .then {
            $0.backgroundColor = .white
            $0.naviType = .push
        }
    
    private let mapVC = MiniMapVC()
        .then {
            $0.hideMagnificationBtn()
            $0.mapView.layer.masksToBounds = false
        }
    
    private let userRankingListStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 12
            $0.distribution = .fillEqually
            $0.alignment = .leading
            
            $0.backgroundColor = .clear
        }
    
    // MARK: - Variables and Properties
    
    var challengeTitle: String?
    
    private let viewModel = ChallengeDetailMapVM()
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
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
    
    // MARK: - Functions
    
    func getChallengeDetailMap(uuid: String) {
        let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""
        viewModel.getChallengeDetailMap(nickname: nickname, uuid: uuid)
    }
    
}

// MARK: - Configure

extension ChallengeDetailMapVC {
    
    private func configureNavigationBar() {
        _ = navigationBar
            .then {
                $0.configureBackBtn(targetVC: self)
                $0.configureNaviBar(targetVC: self, title: challengeTitle)
            }
    }
    
    private func drawUsersRoute(matrixList: [MatrixList], rankingList: [RankingList]) {
        mapVC.isUserInteractionEnabled(true)

        let myUserNickName = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""
        for i in rankingList.indices {
            let matrixInfo = matrixList[i]
            guard let color = ChallengeColorType(rawValue: matrixInfo.color) else {
                print("challenge user color error")
                continue
            }
            
            guard let latitude = matrixInfo.latitude,
                  let longitude = matrixInfo.longitude,
                  let imageURL = URL(string: rankingList[i].picturePath)
            else { continue }
            
            if(rankingList[i].nickname == myUserNickName) {
                mapVC.drawMyMapAtOnce(matrices: matrixInfo.matrices)
                mapVC.addMyAnnotation(coordinate: [latitude, longitude],
                                      profileImageURL: imageURL)
            } else {
                mapVC.drawBlockArea(matrices: matrixInfo.matrices,
                                    owner: .friends,
                                    blockColor: color.blockColor)
                
                mapVC.addFriendAnnotation(coordinate: [latitude, longitude],
                                          profileImageURL: imageURL,
                                          nickname: rankingList[i].nickname,
                                          color: color.primaryColor,
                                          challengeCnt: rankingList[i].rank,
                                          isBorderOn: true)
            }
        }
    }
    
    private func configureUserRankigListStackView(matrixList: [MatrixList], rankingList: [RankingList]) {
        let myUserNickName = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""
        
        for i in rankingList.indices {
            let userRankingView = UIView()
            userRankingView.backgroundColor = .clear
            
            let rankLabel = UILabel()
            rankLabel.font = .caption1
            rankLabel.textColor = .gray700
            rankLabel.text = String(rankingList[i].rank) + "위"
            
            let userProfileImageView = UIImageView()
            userProfileImageView.kf.setImage(with: URL(string: rankingList[i].picturePath))
            userProfileImageView.layer.cornerRadius = 20
            userProfileImageView.layer.masksToBounds = true
            userProfileImageView.layer.borderWidth = 2
            userProfileImageView.layer.borderColor = ChallengeColorType(rawValue: matrixList[i].color)?.primaryColor.cgColor
            
            let userNicknameLabel = UILabel()
            userNicknameLabel.font = .caption1
            userNicknameLabel.textColor = .gray700
            userNicknameLabel.text = rankingList[i].nickname
            
            let blocksNumberLabel = UILabel()
                .then {
                    $0.font = .title3M
                    $0.textColor = .gray900
                }
            blocksNumberLabel.text = String(rankingList[i].score) + "칸"
            
            
            userRankingView.addSubviews([rankLabel,
                                         userProfileImageView,
                                         userNicknameLabel, blocksNumberLabel])
            rankLabel.snp.makeConstraints {
                $0.centerY.equalTo(userRankingView)
                $0.left.equalTo(userRankingView.snp.left)
            }
            userProfileImageView.snp.makeConstraints {
                $0.width.height.equalTo(userProfileImageView.layer.cornerRadius * 2)
                
                $0.verticalEdges.equalTo(userRankingView)
                $0.left.equalTo(rankLabel.snp.right).offset(8)
            }
            
            if(userNicknameLabel.text == myUserNickName) {
                let showMeLabel = UILabel()
                showMeLabel.text = "나"
                showMeLabel.textAlignment = .center
                showMeLabel.textColor = .white
                showMeLabel.font = .PretendardRegular(size: 10)
                
                showMeLabel.layer.cornerRadius = 7
                showMeLabel.layer.masksToBounds = true
                showMeLabel.layer.borderWidth = 1
                showMeLabel.layer.borderColor = UIColor.white.cgColor
                showMeLabel.translatesAutoresizingMaskIntoConstraints = false
                
                showMeLabel.backgroundColor = .secondary
                
                userRankingView.addSubview(showMeLabel)
                showMeLabel.snp.makeConstraints {
                    $0.width.height.equalTo(showMeLabel.layer.cornerRadius * 2)
                    
                    $0.right.bottom.equalTo(userProfileImageView)
                }
            }
            
            userNicknameLabel.snp.makeConstraints {
                $0.top.right.equalTo(userRankingView)
                $0.left.equalTo(userProfileImageView.snp.right).offset(12)
            }
            blocksNumberLabel.snp.makeConstraints {
                $0.top.equalTo(userNicknameLabel.snp.bottom).offset(2)
                $0.left.equalTo(userNicknameLabel.snp.left)
            }
            
            userRankingListStackView.addArrangedSubview(userRankingView)
        }
    }
}

// MARK: - Layout

extension ChallengeDetailMapVC {
    
    private func configureLayout() {
        view.addSubviews([mapVC.view,
                         userRankingListStackView])
        addChild(mapVC)
        
        
        mapVC.view.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.left.right.bottom.equalTo(view)
        }
        
        userRankingListStackView.snp.makeConstraints {
            $0.left.right.equalTo(view).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(22)
        }
    }
    
}

// MARK: - Output

extension ChallengeDetailMapVC {
    
    private func bindUserData() {
        viewModel.output.challengeDetailMap
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.drawUsersRoute(matrixList: data.matrixList,
                                    rankingList: data.rankingList)
                self.configureUserRankigListStackView(matrixList: data.matrixList,
                                                      rankingList: data.rankingList)
            })
            .disposed(by: bag)
    }
    
}
