//
//  WalkingVM.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/09.
//

import Foundation
import RxCocoa
import RxSwift

final class WalkingVM: MainVM {
    // MARK: - Timer
    var timer = Output()
    
    struct Output {
        let driver = Driver<Int>
            .interval(.seconds(1))
            .map { _ in
                return 1
            }
    }
}
