//
//  UIString+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/15.
//

import UIKit

extension String {
    /// 세자리수마다 콤마를 추가한 값을 반환하는 변수
    var insertComma: String {
        guard let number = Int(self) else {
            print("can't insert comma!")
            return self
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}
