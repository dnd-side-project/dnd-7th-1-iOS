//
//  MyRecordListDataSource.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/22.
//

import Foundation
import RxDataSources

struct MyRecordListDataSource {
    var section: Int
    var items: [Item]
}

extension MyRecordListDataSource: SectionModelType {
    typealias Item = ActivityRecord
    init(original: MyRecordListDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
