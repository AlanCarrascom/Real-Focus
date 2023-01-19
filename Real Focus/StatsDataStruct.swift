//
//  StatsViewModel.swift
//  Real Focus
//
//  Created by Alan Carrasco on 18/01/23.
//

import Foundation

struct StatsDataStruct: Identifiable{
    var id = UUID()
    var date: Date
    var minutesCount: Int
}

extension Date{
    static func from(year: Int, month: Int, day: Int) -> Date{
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
