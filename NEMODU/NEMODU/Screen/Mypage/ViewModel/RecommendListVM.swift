//
//  RecommendListVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/23.
//

import Foundation
import RxCocoa
import RxSwift
import KakaoSDKUser
import CoreLocation

final class RecommendListVM: BaseViewModel, AddDeleteFriendProtocol {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Location
    
    var locationManager = CLLocationManager()
    
    // MARK: - AddDeleteFriendProtocol
    
    var requestStatus = PublishRelay<Bool>()
    var deleteStatus = PublishRelay<Bool>()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var loading = BehaviorRelay<Bool>(value: false)
        var kakaoFriendsList = KakaoFriends()
        var nemoduFriendslist = NEMODUFriends()
    }
    
    struct KakaoFriends: FriendListOutput {
        var dataSource: Observable<[FriendListDataSource<KakaoFriendInfo>]> {
            friendsInfo.map { [FriendListDataSource(section: .zero, items: $0)] }
        }
        var friendsInfo = BehaviorRelay<[KakaoFriendInfo]>(value: [])
        var isLast = BehaviorRelay<Bool>(value: true)
        var nextOffset = BehaviorRelay<Int?>(value: 0)
    }
    
    struct NEMODUFriends {
        var dataSource: Observable<[FriendListDataSource<FriendDefaultInfo>]> {
            friendsInfo.map { [FriendListDataSource(section: .zero, items: $0)] }
        }
        var friendsInfo = BehaviorRelay<[FriendDefaultInfo]>(value: [])
        var isLast = BehaviorRelay<Bool>(value: true)
        var nextDistance = BehaviorRelay<Double?>(value: nil)
    }
    
    // MARK: - Init
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Custom Method

extension RecommendListVM {
    /// 현재 위치를 반환하는 메서드.
    /// 위치 동의를 받지 않은 경우 한국 내 랜덤 좌표값 전달
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        locationManager.startUpdatingLocation()
        let coordinate = locationManager.location?.coordinate
        locationManager.stopUpdatingLocation()
        
        if let coordinate = coordinate {
            return coordinate
        } else {
            let randomLatitude = Double.random(in: 35.15972...37.65833)
            let randomLongitude = Double.random(in: 126.45056...129.34167)
            
            return CLLocationCoordinate2D(latitude: randomLatitude,
                                          longitude: randomLongitude)
        }
    }
}

// MARK: - Input

extension RecommendListVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension RecommendListVM: Output {
    func bindOutput() {}
}

// MARK: - Network

extension RecommendListVM {
    /// 카카오 추천 친구 목록 조회 메서드.
    /// 사이즈 3으로 고정
    func getKakaoFriendList(size: Int = 3) {
        let offset = output.kakaoFriendsList.nextOffset.value ?? 0
        let path = "auth/kakao/friend?size=\(size)&offset=\(offset)"
        let resource = urlResource<KakaoFriendListResponseModel>(path: path)
        
        KakaoAPI.shared.getKakaoFriendList(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.kakaoFriendsList.friendsInfo.accept(data.friends)
                    owner.output.kakaoFriendsList.nextOffset.accept(data.offset)
                    owner.output.kakaoFriendsList.isLast.accept(true)
                }
            })
            .disposed(by: bag)
    }
    
    /// 나의 현재 위치를 기반으로 가까이에 있는 네모두 추천 친구 목록을 조회하는 메서드.
    /// 위치 동의를 하지 않았다면 국내 랜덤 지역
    func getNEMODUFriendList(size: Int = 3) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname),
              let coordinate = getCurrentLocation()
        else { fatalError() }
        var path = "friend/recommend?nickname=\(nickname)&size=\(size)&latitude=\(coordinate.latitude)&longitude=\(coordinate.longitude)"
        if let distance = output.nemoduFriendslist.nextDistance.value {
            path += "&distance=\(distance)"
        }
        let resource = urlResource<NEMODUFriendListResponseModel>(path: path)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.nemoduFriendslist.friendsInfo.accept(data.infos)
                    owner.output.nemoduFriendslist.nextDistance.accept(data.offset)
                    owner.output.nemoduFriendslist.isLast.accept(data.isLast)
                }
            })
            .disposed(by: bag)
    }
}
