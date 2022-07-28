//
//  BaseViewModel.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import Foundation
import RxSwift

protocol BaseViewModel: Input, Output {
    var apiSession: APIService { get }
    
    var bag: DisposeBag { get }
}
