//
//  FriendListDataSource.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/14.
//

import Foundation
import RxDataSources

struct FriendListDataSource<T> {
    var section: Int
    var items: [T]
}

extension FriendListDataSource: SectionModelType {
    init(original: FriendListDataSource, items: [T]) {
        self = original
        self.items = items
    }
}
