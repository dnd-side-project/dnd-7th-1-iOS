//
//  Int+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/24.
//

import Foundation

extension Int {
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
    var showTwoDigitNumber: String {
        String(format: "%02d", self)
    }
    
    var toKilometer: String {
        let formatter = LengthFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        if self >= 1000 {
            return formatter.string(fromValue: Double(self) / 1000, unit: LengthFormatter.Unit.kilometer)
        } else {
            // 미터로 표시할 땐 소수점 제거
            let value = Double(self)
            return formatter.string(fromValue: value, unit: LengthFormatter.Unit.meter)
        }
    }
}
