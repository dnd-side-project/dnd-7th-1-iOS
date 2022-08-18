//
//  ProceedingChallengeDataSource.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/08.
//

import Foundation
import RxDataSources

struct ProceedingChallengeDataSource {
    var section: Int
    var items: [Item]
}

extension ProceedingChallengeDataSource: SectionModelType {
    typealias Item = ChallengeElementResponseModel
    
    init(original: ProceedingChallengeDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
