//
//  FriendListDataSource.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/14.
//

import Foundation
import RxDataSources

struct FriendListDataSource {
    var section: Int
    var items: [Item]
}

extension FriendListDataSource: SectionModelType {
    typealias Item = FriendDefaultInfo
    init(original: FriendListDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
