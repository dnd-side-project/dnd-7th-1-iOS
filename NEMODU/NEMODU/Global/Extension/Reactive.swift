//
//  Reactive.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/25.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
