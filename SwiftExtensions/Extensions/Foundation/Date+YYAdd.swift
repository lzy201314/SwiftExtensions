//
//  Date+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's NSDate+YYAdd.
//

import Foundation

extension Date {
    // MARK: - Component Properties
    var year: Int { Calendar.current.component(.year, from: self) }
    var month: Int { Calendar.current.component(.month, from: self) }
    var day: Int { Calendar.current.component(.day, from: self) }
    var hour: Int { Calendar.current.component(.hour, from: self) }
    var minute: Int { Calendar.current.component(.minute, from: self) }
    var second: Int { Calendar.current.component(.second, from: self) }
    var nanosecond: Int { Calendar.current.component(.nanosecond, from: self) }
    var weekday: Int { Calendar.current.component(.weekday, from: self) }
    var weekdayOrdinal: Int { Calendar.current.component(.weekdayOrdinal, from: self) }
    var weekOfMonth: Int { Calendar.current.component(.weekOfMonth, from: self) }
    var weekOfYear: Int { Calendar.current.component(.weekOfYear, from: self) }
    var yearForWeekOfYear: Int { Calendar.current.component(.yearForWeekOfYear, from: self) }
    var quarter: Int { Calendar.current.component(.quarter, from: self) }
    var isLeapMonth: Bool {
        if #available(iOS 17.0, *) {
            return Calendar.current.dateComponents([.isLeapMonth], from: self).isLeapMonth ?? false
        } else {
            return Calendar.current.dateComponents([.month], from: self).isLeapMonth ?? false
        }
    }
    var isLeapYear: Bool {
        let y = year
        return (y % 400 == 0) || ((y % 100 != 0) && (y % 4 == 0))
    }
    var isToday: Bool {
        if abs(timeIntervalSinceNow) >= 60 * 60 * 24 { return false }
        return Calendar.current.isDateInToday(self)
    }
    var isYesterday: Bool {
        guard let added = self.dateByAddingDays(1) else { return false }
        return added.isToday
    }

    // MARK: - Date Modify
    func dateByAddingYears(_ years: Int) -> Date? {
        Calendar.current.date(byAdding: .year, value: years, to: self)
    }
    func dateByAddingMonths(_ months: Int) -> Date? {
        Calendar.current.date(byAdding: .month, value: months, to: self)
    }
    func dateByAddingWeeks(_ weeks: Int) -> Date? {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)
    }
    func dateByAddingDays(_ days: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    func dateByAddingHours(_ hours: Int) -> Date? {
        Calendar.current.date(byAdding: .hour, value: hours, to: self)
    }
    func dateByAddingMinutes(_ minutes: Int) -> Date? {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }
    func dateByAddingSeconds(_ seconds: Int) -> Date? {
        Calendar.current.date(byAdding: .second, value: seconds, to: self)
    }

    // MARK: - Date Format
    func string(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    func string(withFormat format: String, timeZone: TimeZone?, locale: Locale?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let tz = timeZone { formatter.timeZone = tz }
        if let loc = locale { formatter.locale = loc }
        return formatter.string(from: self)
    }
    func stringWithISOFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: self)
    }
    static func date(withString dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
    static func date(withString dateString: String, format: String, timeZone: TimeZone?, locale: Locale?) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let tz = timeZone { formatter.timeZone = tz }
        if let loc = locale { formatter.locale = loc }
        return formatter.date(from: dateString)
    }
    static func dateWithISOFormatString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: dateString)
    }
} 