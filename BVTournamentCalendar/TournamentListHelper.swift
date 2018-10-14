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
        Period(name: "TP 01", number: 1, date: "1 jan - 2 april"),
        Period(name: "TP 02", number: 2, date: "3 april - 20 maj"),
        Period(name: "TP 03", number: 3, date: "21 maj - 3 juni"),
        Period(name: "TP 04", number: 4, date: "4 juni - 10 juni"),
        Period(name: "TP 05", number: 5, date: "11 jun - 24 jun"),
        Period(name: "TP 06", number: 6, date: "25 jun - 1 jul"),
        Period(name: "TP 07", number: 7, date: "2 jul - 8 jul"),
        Period(name: "TP 08", number: 8, date: "9 jul - 15 jul"),
        Period(name: "TP 09", number: 9, date: "16 jul - 22 jul"),
        Period(name: "TP 10", number: 10, date: "23 jul - 29 jul"),
        Period(name: "TP 11", number: 11, date: "30 jul - 5 aug"),
        Period(name: "TP 12", number: 12, date: "6 aug - 12 aug"),
        Period(name: "TP 13", number: 13, date: "13 aug - 19 aug"),
        Period(name: "TP 14", number: 14, date: "20 aug - 2 sep"),
        Period(name: "TP 15", number: 15, date: "3 sep - 14 okt"),
        Period(name: "TP 16", number: 16, date: "15 okt - 31 dec")
    ]

    func getCurrentPeriod() -> Int {
        return self.getPeriodForDate(Foundation.Date()).number
    }
    
    func getPeriodForDate(_ date: Foundation.Date) -> Period {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        

        if(date < formatter.date(from: "20180403")!)
        {
            return periods2016[0]
        }
        if(date < formatter.date(from: "20180521")!)
        {
            return periods2016[1]
        }
        if(date < formatter.date(from: "20180604")!)
        {
            return periods2016[2]
        }
        if(date < formatter.date(from: "20180611")!)
        {
            return periods2016[3]
        }
        if(date < formatter.date(from: "20180625")!)
        {
            return periods2016[4]
        }
        if(date < formatter.date(from: "20180702")!)
        {
            return periods2016[5]
        }
        if(date < formatter.date(from: "20180709")!)
        {
            return periods2016[6]
        }
        if(date < formatter.date(from: "20180716")!)
        {
            return periods2016[7]
        }
        if(date < formatter.date(from: "20180723")!)
        {
            return periods2016[8]
        }
        if(date < formatter.date(from: "20180730")!)
        {
            return periods2016[9]
        }
        if(date < formatter.date(from: "20180806")!)
        {
            return periods2016[10]
        }
        if(date < formatter.date(from: "20180813")!)
        {
            return periods2016[11]
        }
        if(date < formatter.date(from: "20180820")!)
        {
            return periods2016[12]
        }
        if(date < formatter.date(from: "20180903")!)
        {
            return periods2016[13]
        }
        if(date < formatter.date(from: "20181015")!)
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
