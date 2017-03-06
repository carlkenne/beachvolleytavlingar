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
        Period(name: "TP 02", number: 2, date: "3 april - 21 maj"),
        Period(name: "TP 03", number: 3, date: "22 maj - 4 juni"),
        Period(name: "TP 04", number: 4, date: "5 juni - 11 juni"),
        Period(name: "TP 05", number: 5, date: "12 jun - 25 jun"),
        Period(name: "TP 06", number: 6, date: "26 jun - 2 jul"),
        Period(name: "TP 07", number: 7, date: "3 jul - 9 jul"),
        Period(name: "TP 08", number: 8, date: "10 jul - 16 jul"),
        Period(name: "TP 09", number: 9, date: "17 jul - 23 jul"),
        Period(name: "TP 10", number: 10, date: "24 jul - 30 jul"),
        Period(name: "TP 11", number: 11, date: "31 jul - 6 aug"),
        Period(name: "TP 12", number: 12, date: "7 aug - 13 aug"),
        Period(name: "TP 13", number: 13, date: "14 aug - 20 aug"),
        Period(name: "TP 14", number: 14, date: "21 aug - 3 sep"),
        Period(name: "TP 15", number: 15, date: "4 sep - 15 okt"),
        Period(name: "TP 16", number: 16, date: "16 okt - 31 dec")
    ]

    func getCurrentPeriod() -> Int {
        return self.getPeriodForDate(Foundation.Date()).number
    }
    
    func getPeriodForDate(_ date: Foundation.Date) -> Period {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        if(date <= formatter.date(from: "20170402")!)
        {
            return periods2016[0]
        }
        if(date <= formatter.date(from: "20170521")!)
        {
            return periods2016[1]
        }
        if(date <= formatter.date(from: "20170604")!)
        {
            return periods2016[2]
        }
        if(date <= formatter.date(from: "20170611")!)
        {
            return periods2016[3]
        }
        if(date <= formatter.date(from: "20170625")!)
        {
            return periods2016[4]
        }
        if(date <= formatter.date(from: "20170702")!)
        {
            return periods2016[5]
        }
        if(date <= formatter.date(from: "20170709")!)
        {
            return periods2016[6]
        }
        if(date <= formatter.date(from: "20170716")!)
        {
            return periods2016[7]
        }
        if(date <= formatter.date(from: "20170723")!)
        {
            return periods2016[8]
        }
        if(date <= formatter.date(from: "20170730")!)
        {
            return periods2016[9]
        }
        if(date < formatter.date(from: "20170806")!)
        {
            return periods2016[10]
        }
        if(date < formatter.date(from: "20170813")!)
        {
            return periods2016[11]
        }
        if(date < formatter.date(from: "20170820")!)
        {
            return periods2016[12]
        }
        if(date < formatter.date(from: "20170903")!)
        {
            return periods2016[13]
        }
        if(date < formatter.date(from: "20171015")!)
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
