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
    func getPeriodNameForDate(date: NSDate) -> NSString {
        
        if(date.earlierDate(Date.from(year: 2015, month: 3, day: 22)).isEqualToDate(date))
        {
            return "TP 01"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 5, day: 3)).isEqualToDate(date))
        {
            return "TP 02"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 5, day: 24)).isEqualToDate(date))
        {
            return "TP 03"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 5, day: 31)).isEqualToDate(date))
        {
            return "TP 04"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 7)).isEqualToDate(date))
        {
            return "TP 05"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 21)).isEqualToDate(date))
        {
            return "TP 06"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 28)).isEqualToDate(date))
        {
            return "TP 07"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 5)).isEqualToDate(date))
        {
            return "TP 08"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 12)).isEqualToDate(date))
        {
            return "TP 09"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 19)).isEqualToDate(date))
        {
            return "TP 10"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 26)).isEqualToDate(date))
        {
            return "TP 11"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 2)).isEqualToDate(date))
        {
            return "TP 12"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 9)).isEqualToDate(date))
        {
            return "TP 13"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 16)).isEqualToDate(date))
        {
            return "TP 14"
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 30)).isEqualToDate(date))
        {
            return "TP 15"
        }
        return "TP 16"
    }

    func getPeriodNumberForDate(date: NSDate) -> Int{
        
        if(date.earlierDate(Date.from(year: 2015, month: 3, day: 22)).isEqualToDate(date))
        {
            return 1
        }
        if(date.earlierDate(Date.from(year: 2015, month: 5, day: 3)).isEqualToDate(date))
        {
            return 2
        }
        if(date.earlierDate(Date.from(year: 2015, month: 5, day: 24)).isEqualToDate(date))
        {
            return 3
        }
        if(date.earlierDate(Date.from(year: 2015, month: 5, day: 31)).isEqualToDate(date))
        {
            return 4
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 7)).isEqualToDate(date))
        {
            return 5
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 21)).isEqualToDate(date))
        {
            return 6
        }
        if(date.earlierDate(Date.from(year: 2015, month: 6, day: 28)).isEqualToDate(date))
        {
            return 7
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 5)).isEqualToDate(date))
        {
            return 8
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 12)).isEqualToDate(date))
        {
            return 9
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 19)).isEqualToDate(date))
        {
            return 10
        }
        if(date.earlierDate(Date.from(year: 2015, month: 7, day: 26)).isEqualToDate(date))
        {
            return 11
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 2)).isEqualToDate(date))
        {
            return 12
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 9)).isEqualToDate(date))
        {
            return 13
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 16)).isEqualToDate(date))
        {
            return 14
        }
        if(date.earlierDate(Date.from(year: 2015, month: 8, day: 30)).isEqualToDate(date))
        {
            return 15
        }
        return 16
    }
    
    func getPeriodRangeForPeriod(date: NSString) -> String{
        if(date == "TP 01")
        {
            return "1 jan - 22 mars"
        }
        if(date == "TP 02")
        {
            return "23 mars - 3 maj"
        }
        if(date == "TP 03")
        {
            return "4 maj - 24 maj"
        }
        if(date == "TP 04")
        {
            return "25 maj - 31 maj"
        }
        if(date == "TP 05")
        {
            return "1 jun - 7 jun"
        }
        if(date == "TP 06")
        {
            return "8 jun - 21 jun"
        }
        if(date == "TP 07")
        {
            return "22 jun - 28 jun"
        }
        if(date == "TP 08")
        {
            return "29 jun - 5 jul"
        }
        if(date == "TP 09")
        {
            return "6 jul - 12 jul"
        }
        if(date == "TP 10")
        {
            return "13 jul - 19 jul"
        }
        if(date == "TP 11")
        {
            return "20 jul - 26 jul"
        }
        if(date == "TP 12")
        {
            return "27 jul - 2 aug"
        }
        if(date == "TP 13")
        {
            return "3 aug - 9 aug"
        }
        if(date == "TP 14")
        {
            return "10 aug - 16 aug"
        }
        if(date == "TP 15")
        {
            return "17 aug - 30 aug"
        }
        return "31 aug - 31 dec"
    }
}