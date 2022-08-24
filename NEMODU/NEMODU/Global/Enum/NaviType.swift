//
//  NaviType.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/09.
//

import UIKit

enum NaviType {
    case push
    case present
}

extension NaviType {
    var backBtnImage: UIImage {
        switch self {
        case .push:
            return UIImage(named: "pop") ?? UIImage()
        case .present:
            return UIImage(named: "dismiss") ?? UIImage()
        }
    }
}
