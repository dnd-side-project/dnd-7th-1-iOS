//
//  MainVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/17.
//

import RxCocoa
import RxSwift

final class MainVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    /// Annotation 생성을 위한 데이터 타입
    /// (닉네임, 위도, 경도, 프로필URL)
    typealias Pin = (nickname: String, latitude: Double?, longitude: Double?, profileImageURL: URL?)
    
    // MARK: - Input
    
    struct Input {
        /// 유저에 해당하는 영역 색을 저장하는 딕셔너리
        var userTable = [String: UIColor]()
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
        var myLastLocation = PublishRelay<Pin>()
        
        // Matrices
        var myMatrices = PublishRelay<[Matrix]>()
        
        var friendBlocks = PublishRelay<[UserBlockResponseModel]>()
        var challengeFriendBlocks = PublishRelay<[ChallengeBlockResponseModel]>()
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
}

// MARK: - Output

extension MainVM: Output {
    func bindOutput() { }
}

// MARK: - Networking

extension MainVM {
    /// 홈화면 전체 데이터(나의 이번주 영역 수, 챌린지 수, 나와 친구의 마커, 영역)를 받아오는 메서드
    func getHomeData(_ latitude: Double, _ longitude: Double, _ spanDelta: Double = Map.defalutZoomScale) {
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
                    if let user = data.userMatrices {
                        // Annotation
                        owner.output.myLastLocation.accept((user.nickname, user.latitude, user.longitude, user.profileImageURL))
                        // Matrices
                        owner.output.myMatrices.accept(user.matrices ?? [])
                        // UserMatricesNumber
                        owner.output.matricesNumber.accept(user.matricesNumber)
                    }
                    if let friendMatrices = data.friendMatrices {
                        owner.output.friendBlocks.accept(friendMatrices)
                    }
                    if let challengeMatrices = data.challengeMatrices {
                        owner.output.challengeFriendBlocks.accept(challengeMatrices)
                    }
                    // visible status
                    owner.output.myBlocksVisible.accept(data.isShowMine)
                    owner.output.friendVisible.accept(data.isShowFriend)
                    owner.output.myLocationVisible.accept(data.isPublicRecord)
                    
                    // 진행중인 챌린지 개수
                    owner.output.challengeCnt.accept(data.challengesNumber ?? 0)
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
    
    /// 지도 제스쳐 시, 현재 화면에 보이는 영역을 받아오는 메서드
    func getUpdateBlocks(_ latitude: Double, _ longitude: Double, _ spanDelta: Double = Map.defalutZoomScale) {
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
                    // TODO: - 데이터 연결
                    dump(data)
                }
                owner.output.endLoading()
            })
            .disposed(by: bag)
    }
}
