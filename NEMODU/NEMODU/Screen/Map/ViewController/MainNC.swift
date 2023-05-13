//
//  MainNC.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/05/13.
//

import UIKit

class MainNC: BaseNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([MainVC()], animated: true)
    }
}
