//
//  CalendarISO8601.swift
//  StepperApp
//
//  Created by Ruben Egikian on 01.12.2021.
//

import Foundation

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
    static let iso8601UTC: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
}

extension Date {
    var mondayOfTheSameWeek: Date {
        Calendar.iso8601.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    var mondayOfTheSameWeekAtUTC: Date {
        Calendar.iso8601UTC.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
}
