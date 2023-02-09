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
    
    private let mapVC = ChallengeDetailMiniMapVC()
    
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
    
    let viewModel = ChallengeDetailMapVM()
    var challengeDetailMapResponseModel: ChallengeDetailMapResponseModel?
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
        configureMapVC()
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
    
    /// 상세보기 이전, 미니맵 화면에서 나의 블록 영역을 받아오는 메서드
    func getBlocks(blocks: [[Double]]) {
        mapVC.blocks = blocks
    }
    
    private func drawUsersBlocks() {
        mapVC.isUserInteractionEnabled(true)
        
        var availableMatrixCnt = 0.0
        
        var totalLatitude = 0.0
        var totalLongitude = 0.0
        
        var minLatitude = 90.0 + 1.0
        var maxLatitude = 0.0
        
        var minLongitude = 180.0 + 1.0
        var maxLongitude = 0.0
        
        challengeDetailMapResponseModel?.matrixList.forEach {
            guard
                let targetLatitude = $0.latitude,
                let targetLongitude = $0.longitude,
                let profileImageURL = URL(string: $0.picturePath),
                let blockColor = ChallengeColorType(rawValue: $0.color)?.blockColor // TODO: - 사용자 블록색깔 오류 작업
            else { return print("matrixList Data error") }
            
            mapVC.addFriendColoredAnnotation(coordinate: [targetLatitude, targetLongitude], profileImageURL: profileImageURL, color: blockColor)
            mapVC.drawBlockArea(blocks: $0.matrices, owner: .friends, blockColor: blockColor)
            
            availableMatrixCnt += 1.0
            
            totalLatitude += targetLatitude
            totalLongitude += targetLongitude
            
            minLatitude = min(minLatitude, abs(targetLatitude))
            maxLatitude = max(maxLatitude, abs(targetLatitude))
            
            minLongitude = min(minLongitude, abs(targetLongitude))
            maxLongitude = max(maxLongitude, abs(targetLongitude))
        }
        
        let centerLatitude = totalLatitude / availableMatrixCnt
        let centerLongtitde = totalLongitude / availableMatrixCnt

        var zoomScale = maxLongitude - minLongitude
        zoomScale += mapVC.longitudeBlockSizePoint * 6.0

        _ = mapVC.goLocation(latitudeValue: centerLatitude, longitudeValue: centerLongtitde, delta: zoomScale)
    }
    
}

// MARK: - Configure

extension ChallengeDetailMapVC {
    
    private func configureNavigationBar() {
        _ = navigationBar
            .then {
                $0.configureNaviBar(targetVC: self, title: challengeTitle)
                $0.configureBackBtn(targetVC: self)
            }
    }
    
    private func configureMapVC() {
        _ = mapVC.then {
            $0.hideMagnificationBtn()
            $0.mapView.layer.masksToBounds = false
        }
    }
    
    private func configureUserRankigListStackView() {
        guard let myUserNickName = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { return }
        
        challengeDetailMapResponseModel?.rankingList.forEach {
            let userRankingView = UIView()
            userRankingView.backgroundColor = .clear
            
            let rankLabel = UILabel()
            rankLabel.font = .caption1
            rankLabel.textColor = .gray700
            rankLabel.text = String($0.rank) + "위"
            
            let userProfileImageView = UIImageView()
            userProfileImageView.kf.setImage(with: URL(string: $0.picturePath))
            userProfileImageView.layer.cornerRadius = 20
            userProfileImageView.layer.masksToBounds = true
            userProfileImageView.layer.borderWidth = 2
            userProfileImageView.layer.borderColor = UIColor.pink100.cgColor
            // TODO: - 사용자 프로필 이미지 라운드 색깔 작업
            
            let userNicknameLabel = UILabel()
            userNicknameLabel.font = .caption1
            userNicknameLabel.textColor = .gray700
            userNicknameLabel.text = $0.nickname
            
            let blocksNumberLabel = UILabel()
                .then {
                    $0.font = .title3M
                    $0.textColor = .gray900
                }
            blocksNumberLabel.text = String($0.score) + "칸"
            
            
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

// MARK: - Input

extension ChallengeDetailMapVC {
}

// MARK: - Output

extension ChallengeDetailMapVC {
    
    private func bindUserData() {
        viewModel.output.challengeDetailMap
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.challengeDetailMapResponseModel = data
                self.drawUsersBlocks()
                self.configureUserRankigListStackView()
            })
            .disposed(by: bag)
    }
    
}
