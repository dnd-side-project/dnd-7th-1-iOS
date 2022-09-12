//
//  LoginNC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/12.
//

import UIKit

class LoginNC: BaseNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([LoginVC()], animated: true)
    }
}
