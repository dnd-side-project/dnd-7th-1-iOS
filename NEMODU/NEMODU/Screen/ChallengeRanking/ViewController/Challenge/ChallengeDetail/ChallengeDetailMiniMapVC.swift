//
//  ChallengeDetailMiniMapVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/01/20.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import MapKit
import Kingfisher

class ChallengeDetailMiniMapVC: MapVC {
    
    // MARK: - UI components
    
    private let magnificationBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "magnification"), for: .normal)
            $0.addShadow()
        }
    
    // MARK: - Variables and Properties
    
    var challengeTitle: String?
    var uuid: String?
    
    private let bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
        configureMiniMap()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension ChallengeDetailMiniMapVC {
    
    private func configureMiniMap() {
        isFocusOn = false
        isWalking = false
        
        // configure map as read only
        mapView.mapType = .standard
        mapView.showsUserLocation = false
        mapView.layer.cornerRadius = 15
        isUserInteractionEnabled(false)
    }
    
    /// 나의 영역을 기준으로 지도가 한 눈에 보이게 미니맵을 그리는 함수
    func drawChallengeDetailMiniMap() {
        let sortedLatitude = blocks.sorted(by: { $0[0] < $1[0] })
        let sortedLongitude = blocks.sorted(by: { $0[1] < $1[1] })
        
        // 영역이 없는 경우 그냥 return & 그냥 현재 위치의 기본 지도가 뜸
        guard let lastLatitude = sortedLatitude.last,
              let firstLatitude = sortedLatitude.first,
              let lastLongitude = sortedLongitude.last,
              let firstLongitude = sortedLongitude.first else { return }
        
        let spanX = Int((lastLatitude[0] - firstLatitude[0]) / latitudeBlockSizePoint)
        let spanY = Int((lastLongitude[1] - firstLongitude[1]) / longitudeBlockSizePoint)
        var span = Double(spanX > spanY ? spanX : spanY)
        span = (span + 3) * longitudeBlockSizePoint
        
        _ = goLocation(latitudeValue: sortedLatitude[blocks.count/2][0],
                       longitudeValue: sortedLongitude[blocks.count/2][1],
                       delta: span)
        
        drawBlockArea(blocks: blocks,
                      owner: .mine,
                      blockColor: .main40)
    }
    
    /// miniMap의 확대 버튼을 숨기는 메서드
    func hideMagnificationBtn() {
        magnificationBtn.isHidden = true
    }
    
}

// MARK: - Layout

extension ChallengeDetailMiniMapVC {
    
    private func configureLayout() {
        view.addSubview(magnificationBtn)
        
        mapView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        magnificationBtn.snp.makeConstraints {
            $0.right.bottom.equalTo(view).offset(-16)
            $0.height.width.equalTo(48)
        }
    }
    
}

// MARK: - Input

extension ChallengeDetailMiniMapVC {
    
    private func bindButton() {
        magnificationBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let challengeDetailMapVC = ChallengeDetailMapVC()
                challengeDetailMapVC.viewModel.getChallengeDetailMap(uuid: self.uuid ?? "")
                challengeDetailMapVC.challengeTitle = self.challengeTitle
                
                self.navigationController?.pushViewController(challengeDetailMapVC, animated: true)
            })
            .disposed(by: bag)
    }
    
}
