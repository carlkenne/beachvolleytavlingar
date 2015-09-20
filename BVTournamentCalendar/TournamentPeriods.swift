//
//  TournamentPeriods.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation
import UIKit

class TournamentPeriods {
    func getPeriodNameForDate(date: NSDate) -> String {
        
        if(date.earlierDate(Date.from(year: 2015, month: 3, day: 23)).isEqualToDate(date))
        {
            return "TP 01"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 5, day: 4)).isEqualToDate(date))
        {
            return "TP 02"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 5, day: 25)).isEqualToDate(date))
        {
            return "TP 03"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 1)).isEqualToDate(date))
        {
            return "TP 04"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 8)).isEqualToDate(date))
        {
            return "TP 05"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 22)).isEqualToDate(date))
        {
            return "TP 06"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 29)).isEqualToDate(date))
        {
            return "TP 07"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 6)).isEqualToDate(date))
        {
            return "TP 08"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 13)).isEqualToDate(date))
        {
            return "TP 09"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 20)).isEqualToDate(date))
        {
            return "TP 10"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 27)).isEqualToDate(date))
        {
            return "TP 11"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 3)).isEqualToDate(date))
        {
            return "TP 12"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 10)).isEqualToDate(date))
        {
            return "TP 13"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 17)).isEqualToDate(date))
        {
            return "TP 14"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 31)).isEqualToDate(date))
        {
            return "TP 15"
        }
        return "TP 16"
    }

    func getDateRangeForPeriod(periodName: NSString) -> String{
        if(periodName == "TP 01")
        {
            return "1 jan - 22 mars"
        }
        if(periodName == "TP 02")
        {
            return "23 mars - 3 maj"
        }
        if(periodName == "TP 03")
        {
            return "4 maj - 24 maj"
        }
        if(periodName == "TP 04")
        {
            return "25 maj - 31 maj"
        }
        if(periodName == "TP 05")
        {
            return "1 jun - 7 jun"
        }
        if(periodName == "TP 06")
        {
            return "8 jun - 21 jun"
        }
        if(periodName == "TP 07")
        {
            return "22 jun - 28 jun"
        }
        if(periodName == "TP 08")
        {
            return "29 jun - 5 jul"
        }
        if(periodName == "TP 09")
        {
            return "6 jul - 12 jul"
        }
        if(periodName == "TP 10")
        {
            return "13 jul - 19 jul"
        }
        if(periodName == "TP 11")
        {
            return "20 jul - 26 jul"
        }
        if(periodName == "TP 12")
        {
            return "27 jul - 2 aug"
        }
        if(periodName == "TP 13")
        {
            return "3 aug - 9 aug"
        }
        if(periodName == "TP 14")
        {
            return "10 aug - 16 aug"
        }
        if(periodName == "TP 15")
        {
            return "17 aug - 30 aug"
        }
        return "31 aug - 31 dec"
    }
}