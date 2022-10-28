//
//  Date.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation
import UIKit

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date, to todate: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: todate).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date, to todate: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: todate).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date, to todate: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: todate).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date, to todate: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: todate).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date, to todate: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: todate).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date, to todate: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: todate).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date, to todate: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: todate).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date, to todate: Date) -> String {
        if years(from: date, to: todate)   > 0 { return years(from: date, to: todate) == 1 ? "\(years(from: date, to: todate)) \("DATA_CAR_DETAILS_YEAR")" : "\(years(from: date, to: todate)) \("YEARS")"   }
        if months(from: date, to: todate)  > 0 { return months(from: date, to: todate) == 1 ? "\(months(from: date, to: todate)) \("DURATION_MONTH")" : "\(months(from: date, to: todate)) \("DURATION_MONTHS")"  }
        if weeks(from: date, to: todate)   > 0 { return weeks(from: date, to: todate) == 1 ? "\(weeks(from: date, to: todate)) \("WEEK")" : "\(weeks(from: date, to: todate)) \("WEEKS")"   }
        if days(from: date, to: todate)    > 0 { return days(from: date, to: todate) == 1 ? "\(days(from: date, to: todate)) \("DAY")" : "\(days(from: date, to: todate)) \("DAYS")"    }
        if hours(from: date, to: todate)   > 0 { return hours(from: date, to: todate) == 1 ? "\(hours(from: date, to: todate)) \("HOUR")" : "\(hours(from: date, to: todate)) \("HOURS")"   }
        if minutes(from: date, to: todate) > 0 { return minutes(from: date, to: todate) > 1 ? "\(minutes(from: date, to: todate)) \("MINUTE")" : "\(minutes(from: date, to: todate)) \("MINUTES")" }
        if seconds(from: date, to: todate) > 0 { return seconds(from: date, to: todate) == 1 ? "\(seconds(from: date, to: todate)) \("SECOND")" : "\(seconds(from: date, to: todate)) \("SECONDS")" }
        return ""
    }
    
    func convertDateFormat(_ date: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: date)
        return date
    }
}

extension Formatter {
    static let monthMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
    static let hour12: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    static let minute0x: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
    static let amPM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter
    }()
    static let dayFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
}

extension Date {
    //    let hour = date.hour12
    //    let minutes = date.minute0x
    //    let amPm = date.amPM
    //    "Today \(hour):\(minutes) \(amPm)"
    
    var monthMedium: String { return Formatter.monthMedium.string(from: self) }
    var hour12: String { return Formatter.hour12.string(from: self) }
    var minute0x: String { return Formatter.minute0x.string(from: self) }
    var amPM: String { return Formatter.amPM.string(from: self) }
    var dayFormat: String { return Formatter.dayFormat.string(from: self) }
}

extension Date {
    func isBetween(_ date1: Date, _ date2: Date) -> Bool {
        return date1 < date2
        ? DateInterval(start: date1, end: date2).contains(self)
        : DateInterval(start: date2, end: date1).contains(self)
    }
}


extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(_ format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
}
