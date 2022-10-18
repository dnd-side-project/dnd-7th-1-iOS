//
//  Date+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/26.
//

import Foundation

extension Date {
    func toString(separator: DateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = separator.dateFormatter
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.string(from: self)
    }
    
    /// Date에서 특정 component를 반환하는 메서드
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    /// Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// 월요일부터 시작하는 NEMODU weekDay
    func getWeekDay() -> Int {
        let weekDay = self.get(.weekday)
        
        switch weekDay {
        case 1:
            return 6
        default:
            return weekDay - 2
        }
    }
}
