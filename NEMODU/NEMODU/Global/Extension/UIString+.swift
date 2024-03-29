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
    
    /// Date String을 Date 타입으로 반환하는 함수
    func toDate(_ dateType: DateType) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateType.dateFormatter
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("toDate() convert error")
            return Date()
        }
    }
    
    /// Date String을 RelativeDateTime 타입으로 반환하는 함수
    func relativeDateTime(_ dateType: DateType) -> String {
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.dateTimeStyle = .numeric
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let relativeDate = dateFormatter.localizedString(for: self.toDate(dateType), relativeTo: Date.now)
        return relativeDate
    }
    
    /// 인코딩한 string을 반환하는 메서드
    func encodeURL() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
