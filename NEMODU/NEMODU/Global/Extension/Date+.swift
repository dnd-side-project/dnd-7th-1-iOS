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
    
    /// 특정 날짜의 요일을 반환(ex, 화)
    func getDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: self)
        return convertStr
    }
    
    /// 특정 날짜의 시간을 반환
    func toTime(_ dateFormatter: DateType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter.dateFormatter
        formatter.locale = Locale(identifier: "ko_KR")
        let time = formatter.string(from: self)
        return time
    }
}

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var second: Int {
        Calendar.current.component(.second, from: self)
    }
}
