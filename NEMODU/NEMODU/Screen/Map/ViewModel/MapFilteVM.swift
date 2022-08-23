//
//  MapFilteVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/24.
//

import Foundation
import RxCocoa
import RxSwift

final class MapFilterVM: BaseViewModel {
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    
    struct Input {}
    
    // MARK: - Output
    
    struct Output {}
    
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
        // TODO: - UserDefaults 수정
        let nickname = "NickA"
        let path = "user/filter/friend?nickname=\(nickname)"
        let resource = urlResource<String>(path: path)
        
        apiSession.postRequest(with: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    dump(data)
                }
            })
            .disposed(by: bag)
    }
    
    func postMyAreaVisibleToggle() {
        // TODO: - UserDefaults 수정
        let nickname = "NickA"
        let path = "user/filter/mine?nickname=\(nickname)"
        let resource = urlResource<String>(path: path)
        
        apiSession.postRequest(with: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    dump(data)
                }
            })
            .disposed(by: bag)
    }
    
    func postMyLocationVisibleToggle() {
        // TODO: - UserDefaults 수정
        let nickname = "NickA"
        let path = "user/filter/record?nickname=\(nickname)"
        let resource = urlResource<String>(path: path)
        
        apiSession.postRequest(with: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                case .success(let data):
                    dump(data)
                }
            })
            .disposed(by: bag)
    }
}
