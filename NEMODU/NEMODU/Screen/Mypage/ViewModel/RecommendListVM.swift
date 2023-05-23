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

final class RecommendListVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {
        var loading = BehaviorRelay<Bool>(value: false)
        var kakaoFriendsList = KakaoFriends()
    }
    
    struct KakaoFriends: FriendListOutput {
        var dataSource: Observable<[FriendListDataSource<KakaoFriendInfo>]> {
            friendsInfo.map { [FriendListDataSource(section: .zero, items: $0)] }
        }
        var friendsInfo = BehaviorRelay<[KakaoFriendInfo]>(value: [])
        var isLast = BehaviorRelay<Bool>(value: true)
        var nextOffset = BehaviorRelay<Int?>(value: 0)
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
    func getKakaoFriendList() {
        let path = "auth/kakao/friend?size=\(3)&offset=\(0)"
        let resource = urlResource<KakaoFriendListResponseModel>(path: path)
        
        KakaoAPI.shared.getKakaoFriendList(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.kakaoFriendsList.friendsInfo.accept(data.friends)
                    owner.output.kakaoFriendsList.isLast.accept(true)
                }
            })
            .disposed(by: bag)
    }
}
