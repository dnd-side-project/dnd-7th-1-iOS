//
//  Int+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/24.
//

import Foundation

extension Int {
    /// 콤마(,)를 추가한 String 반환
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
    /// 두 자리로 formatting한 String 반환
    var showTwoDigitNumber: String {
        String(format: "%02d", self)
    }
    
    /// m를 km로 반환
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
    
    /// 네모두만의 운동 시간 표현 (초 -> 분:초)
    /// 60분 넘어가도 분으로만 표현 & 분은 한자리 표현 & 초는 두 자리 표현
    var toExerciseTime: String {
        let m = self / 60
        let s = self % 60
        
        return "\(m):\(s.showTwoDigitNumber)"
    }
}
