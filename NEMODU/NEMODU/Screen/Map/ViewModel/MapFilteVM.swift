//
//  MapFilteVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol MapFilterViewModelOutput: Lodable {
    var myBlocksVisible: PublishRelay<Bool> { get }
    var friendVisible: PublishRelay<Bool> { get }
    var myLocationVisible: PublishRelay<Bool> { get }
}

final class MapFilterVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output: MapFilterViewModelOutput {
        var loading = BehaviorRelay<Bool>(value: false)
        var myBlocksVisible = PublishRelay<Bool>()
        var friendVisible = PublishRelay<Bool>()
        var myLocationVisible = PublishRelay<Bool>()
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

extension MapFilterVM {}

// MARK: - Input

extension MapFilterVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension MapFilterVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension MapFilterVM {
    func postFriendVisibleToggle() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "user/filter/friend?nickname=\(nickname)"
        let resource = urlResource<Bool>(path: path)
        
        apiSession.postRequest(with: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.friendVisible.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func postMyAreaVisibleToggle() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "user/filter/mine?nickname=\(nickname)"
        let resource = urlResource<Bool>(path: path)
        
        apiSession.postRequest(with: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.myBlocksVisible.accept(data)
                }
            })
            .disposed(by: bag)
    }
    
    func postMyLocationVisibleToggle() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) else { fatalError() }
        let path = "user/filter/record?nickname=\(nickname)"
        let resource = urlResource<Bool>(path: path)
        
        apiSession.postRequest(with: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    owner.output.myLocationVisible.accept(data)
                }
            })
            .disposed(by: bag)
    }
}
