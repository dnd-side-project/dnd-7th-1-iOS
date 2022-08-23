//
//  MypageNC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/22.
//

import UIKit

class MypageNC: BaseNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([MypageVC()], animated: true)
    }
}
