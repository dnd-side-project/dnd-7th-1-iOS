//
//  RecordResultNC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/19.
//

import UIKit

class RecordResultNC: BaseNavigationController {
    let recordResultVC = RecordResultVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([recordResultVC], animated: true)
    }
}
