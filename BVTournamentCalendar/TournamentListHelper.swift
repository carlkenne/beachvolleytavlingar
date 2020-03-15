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
        Period(name: "TP 01", number: 1, date: "1 jan - 31 mars"),
        Period(name: "TP 02", number: 2, date: "1 april - 19 maj"),
        Period(name: "TP 03", number: 3, date: "20 maj - 2 juni"),
        Period(name: "TP 04", number: 4, date: "3 juni - 9 juni"),
        Period(name: "TP 05", number: 5, date: "10 jun - 23 jun"),
        Period(name: "TP 06", number: 6, date: "24 jun - 30 jun"),
        Period(name: "TP 07", number: 7, date: "1 jul - 7 jul"),
        Period(name: "TP 08", number: 8, date: "8 jul - 14 jul"),
        Period(name: "TP 09", number: 9, date: "15 jul - 21 jul"),
        Period(name: "TP 10", number: 10, date: "22 jul - 29 jul"),
        Period(name: "TP 11", number: 11, date: "30 jul - 4 aug"),
        Period(name: "TP 12", number: 12, date: "5 aug - 11 aug"),
        Period(name: "TP 13", number: 13, date: "12 aug - 18 aug"),
        Period(name: "TP 14", number: 14, date: "19 aug - 1 sep"),
        Period(name: "TP 15", number: 15, date: "2 sep - 13 okt"),
        Period(name: "TP 16", number: 16, date: "14 okt - 31 dec")
    ]

    func getCurrentPeriod() -> Int {
        return self.getPeriodForDate(Foundation.Date()).number
    }
    
    func getPeriodForDate(_ date: Foundation.Date) -> Period {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"

        if(date < formatter.date(from: "20200401")!)
        {
            return periods2016[0]
        }
        if(date < formatter.date(from: "20200520")!)
        {
            return periods2016[1]
        }
        if(date < formatter.date(from: "20200603")!)
        {
            return periods2016[2]
        }
        if(date < formatter.date(from: "20200610")!)
        {
            return periods2016[3]
        }
        if(date < formatter.date(from: "20200624")!)
        {
            return periods2016[4]
        }
        if(date < formatter.date(from: "20200701")!)
        {
            return periods2016[5]
        }
        if(date < formatter.date(from: "20200708")!)
        {
            return periods2016[6]
        }
        if(date < formatter.date(from: "20200715")!)
        {
            return periods2016[7]
        }
        if(date < formatter.date(from: "20200722")!)
        {
            return periods2016[8]
        }
        if(date < formatter.date(from: "20200730")!)
        {
            return periods2016[9]
        }
        if(date < formatter.date(from: "20200805")!)
        {
            return periods2016[10]
        }
        if(date < formatter.date(from: "20200812")!)
        {
            return periods2016[11]
        }
        if(date < formatter.date(from: "20200819")!)
        {
            return periods2016[12]
        }
        if(date < formatter.date(from: "20200902")!)
        {
            return periods2016[13]
        }
        if(date < formatter.date(from: "20201014")!)
        {
            return periods2016[14]
        }
        return periods2016[15]
    }

    func getDateRangeForPeriod(_ periodName: NSString) -> String {
        return periods2016.filter( {(period: Period) -> Bool in
            period.name == periodName as String
        })[0].date
    }
}
