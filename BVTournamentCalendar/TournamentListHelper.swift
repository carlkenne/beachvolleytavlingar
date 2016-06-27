//
//  TournamentPeriods.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation
import UIKit

struct Period {
    let name: String
    let number: Int
    let date: String
}

class TournamentListHelper {
    
    let periods2016 = [
        Period(name: "TP 01", number: 1, date: "1 jan - 3 april"),
        Period(name: "TP 02", number: 2, date: "4 april - 22 maj"),
        Period(name: "TP 03", number: 3, date: "4 april - 22 maj"),
        Period(name: "TP 04", number: 4, date: "7 juni - 12 juni"),
        Period(name: "TP 05", number: 5, date: "13 jun - 26 jun"),
        Period(name: "TP 06", number: 6, date: "27 jun - 3 jul"),
        Period(name: "TP 07", number: 7, date: "4 jul - 10 jul"),
        Period(name: "TP 08", number: 8, date: "11 jul - 17 jul"),
        Period(name: "TP 09", number: 9, date: "18 jul - 24 jul"),
        Period(name: "TP 10", number: 10, date: "25 jul - 31 jul"),
        Period(name: "TP 11", number: 11, date: "1 aug - 7 aug"),
        Period(name: "TP 12", number: 12, date: "8 aug - 14 aug"),
        Period(name: "TP 13", number: 13, date: "15 aug - 21 aug"),
        Period(name: "TP 14", number: 14, date: "22 aug - 4 sep"),
        Period(name: "TP 15", number: 15, date: "5 sep - 16 okt"),
        Period(name: "TP 16", number: 16, date: "17 okt - 31 dec")
    ]

    func getCurrentPeriod() -> Int {
        return self.getPeriodForDate(NSDate()).number
    }
    
    func getPeriodForDate(date: NSDate) -> Period {
        
        if(date.earlierDate(Date.from(year: 2016, month: 4, day: 3)).isEqualToDate(date))
        {
            return periods2016[0]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 5, day: 23)).isEqualToDate(date))
        {
            return periods2016[1]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 6, day: 7)).isEqualToDate(date))
        {
            return periods2016[2]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 6, day: 13)).isEqualToDate(date))
        {
            return periods2016[3]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 6, day: 27)).isEqualToDate(date))
        {
            return periods2016[4]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 4)).isEqualToDate(date))
        {
            return periods2016[5]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 11)).isEqualToDate(date))
        {
            return periods2016[6]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 18)).isEqualToDate(date))
        {
            return periods2016[7]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 25)).isEqualToDate(date))
        {
            return periods2016[8]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 8, day: 1)).isEqualToDate(date))
        {
            return periods2016[9]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 8, day: 8)).isEqualToDate(date))
        {
            return periods2016[10]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 8, day: 15)).isEqualToDate(date))
        {
            return periods2016[11]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 8, day: 22)).isEqualToDate(date))
        {
            return periods2016[12]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 9, day: 5)).isEqualToDate(date))
        {
            return periods2016[13]
        }
        if(date.earlierDate(Date.from(year: 2016, month: 10, day: 17)).isEqualToDate(date))
        {
            return periods2016[14]
        }
        return periods2016[15]
    }

    func getDateRangeForPeriod(periodName: NSString) -> String {
        return periods2016.filter( {(period: Period) -> Bool in
            period.name == periodName
        })[0].date
    }
}