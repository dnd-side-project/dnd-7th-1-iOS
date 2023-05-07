//
//  MainVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/17.
//

import RxCocoa
import RxSwift

class MainVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {
        /// 유저에 해당하는 영역 색을 저장하는 딕셔너리
        var userTable = [String: ChallengeColorType]()
    }
    
    // MARK: - Output
    
    struct Output: Lodable {
        // 로딩
        var loading = BehaviorRelay<Bool>(value: false)
        
        // 필터 - visible
        var myBlocksVisible = BehaviorRelay<Bool>(value: false)
        var friendVisible = BehaviorRelay<Bool>(value: false)
        var myLocationVisible = BehaviorRelay<Bool>(value: false)
        
        // 홈화면 데이터
        var matricesNumber = PublishRelay<Int?>()
        var challengeCnt = PublishRelay<Int>()
        
        // Annotation
        var myLastLocation = PublishRelay<UserBlockResponseModel>()
        var friendsLastLocations = PublishRelay<UserBlockResponseModel>()
        var challengeFriendsLastLocations = PublishRelay<ChallengeBlockResponseModel>()
        
        // Matrices
        var matrices = PublishRelay<(String, [Matrix])>()
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

// MARK: - Helpers

extension MainVM {}

// MARK: - Input

extension MainVM: Input {
    func bindInput() { }
    
    func register(challengeColorType: ChallengeColorType?, of nickname: String) {
        input.userTable[nickname] = challengeColorType
    }
}

// MARK: - Output

extension MainVM: Output {
    func bindOutput() { }
}

// MARK: - Networking

extension MainVM {
    /// 홈화면 전체 데이터(나의 이번주 영역 수, 챌린지 수, 나와 친구의 마커, 영역)를 받아오는 메서드
    func getHomeData(_ latitude: Double, _ longitude: Double, _ spanDelta: Double = Map.defaultZoomScale * 1.5) {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "user/home?nickname=\(nickname)&latitude=\(latitude)&longitude=\(longitude)&spanDelta=\(spanDelta)"
        let resource = urlResource<MainMapResponseModel>(path: path)
        
        output.beginLoading()
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    // 진행중인 챌린지 개수
                    owner.output.challengeCnt.accept(data.challengesNumber ?? 0)
                    
                    // visible status
                    owner.output.myBlocksVisible.accept(data.isShowMine)
                    owner.output.friendVisible.accept(data.isShowFriend)
                    owner.output.myLocationVisible.accept(data.isPublicRecord)
                    
                    if let user = data.userMatrices {
                        // register
                        owner.register(challengeColorType: ChallengeColorType.green, of: user.nickname)
                        // Annotation
                        owner.output.myLastLocation.accept(user)
                        // Matrices
                        owner.output.matrices.accept((user.nickname, user.matrices ?? []))
                        // UserMatricesNumber
                        owner.output.matricesNumber.accept(user.matricesNumber)
                    }
                    if let friendMatrices = data.friendMatrices {
                        for friend in friendMatrices {
                            // register
                            owner.register(challengeColorType: ChallengeColorType.gray, of: friend.nickname)
                            // Annotation
                            owner.output.friendsLastLocations.accept(friend)
                            // Matrices
                            owner.output.matrices.accept((friend.nickname, friend.matrices ?? []))
                        }
                    }
                    if let challengeMatrices = data.challengeMatrices {
                        for friend in challengeMatrices {
                            // register
                            owner.register(challengeColorType: ChallengeColorType(rawValue: friend.challengeColor), of: friend.nickname)
                            // Annotation
                            owner.output.challengeFriendsLastLocations.accept(friend)
                            // Matrices
                            owner.output.matrices.accept((friend.nickname, friend.matrices ?? []))
                        }
                    }
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
    
    /// 지도 제스쳐 시, 현재 화면에 보이는 영역을 받아오는 메서드
    func getUpdateBlocks(_ latitude: Double, _ longitude: Double, _ spanDelta: Double = Map.defaultZoomScale * 1.5) {
        // 필터가 모두 꺼져있으면 통신 진행 X
        if !output.myBlocksVisible.value && !output.friendVisible.value { return }
        
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let type = MapType.all.rawValue
        let path = "matrix?nickname=\(nickname)&latitude=\(latitude)&longitude=\(longitude)&spanDelta=\(spanDelta)&type=\(type)"
        let resource = urlResource<[UserMatrixResponseModel]?>(path: path)
        
        output.beginLoading()
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    guard let data = data else { return }
                    for data in data {
                        owner.output.matrices.accept((data.nickname, data.matrices))
                    }
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
}
