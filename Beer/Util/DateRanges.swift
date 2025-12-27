//
//  DateRanges.swift
//  Beer
//
//  Created by Travis Hand on 12/15/25.
//
import Foundation

enum DateRanges {
    static func today(now: Date = Date(), cal: Calendar = .current) -> Range<Date> {
        let start = cal.startOfDay(for: now)
        let end = cal.date(byAdding: .day, value: 1, to: start)!
        return start..<end
    }

    static func thisWeek(now: Date = Date(), cal: Calendar = .current) -> Range<Date> {
        let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let end = cal.date(byAdding: .day, value: 7, to: start)!
        return start..<end
    }

    static func thisMonth(now: Date = Date(), cal: Calendar = .current) -> Range<Date> {
        let comps = cal.dateComponents([.year, .month], from: now)
        let start = cal.date(from: comps)!
        let end = cal.date(byAdding: .month, value: 1, to: start)!
        return start..<end
    }
}
