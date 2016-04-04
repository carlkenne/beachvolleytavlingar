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
        
        if(date.earlierDate(Date.from(year: 2016, month: 4, day: 3)).isEqualToDate(date))
        {
            return "TP 01"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 5, day: 33)).isEqualToDate(date))
        {
            return "TP 02"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 6, day: 6)).isEqualToDate(date))
        {
            return "TP 03"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 6, day: 12)).isEqualToDate(date))
        {
            return "TP 04"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 6, day: 26)).isEqualToDate(date))
        {
            return "TP 05"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 3)).isEqualToDate(date))
        {
            return "TP 06"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 10)).isEqualToDate(date))
        {
            return "TP 07"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 17)).isEqualToDate(date))
        {
            return "TP 08"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 24)).isEqualToDate(date))
        {
            return "TP 09"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 7, day: 31)).isEqualToDate(date))
        {
            return "TP 10"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 8, day: 7)).isEqualToDate(date))
        {
            return "TP 11"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 8, day: 14)).isEqualToDate(date))
        {
            return "TP 12"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 8, day: 21)).isEqualToDate(date))
        {
            return "TP 13"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 9, day: 4)).isEqualToDate(date))
        {
            return "TP 14"
        }
        if(date.earlierDate(Date.from(year: 2016, month: 10, day: 16)).isEqualToDate(date))
        {
            return "TP 15"
        }
        return "TP 16"
    }

    func getDateRangeForPeriod(periodName: NSString) -> String{
        if(periodName == "TP 01")
        {
            return "1 jan - 3 april"
        }
        if(periodName == "TP 02")
        {
            return "4 april - 22 maj"
        }
        if(periodName == "TP 03")
        {
            return "23 maj - 6 juni"
        }
        if(periodName == "TP 04")
        {
            return "7 juni - 12 juni"
        }
        if(periodName == "TP 05")
        {
            return "13 jun - 26 jun"
        }
        if(periodName == "TP 06")
        {
            return "27 jun - 3 jul"
        }
        if(periodName == "TP 07")
        {
            return "4 jul - 10 jul"
        }
        if(periodName == "TP 08")
        {
            return "11 jul - 17 jul"
        }
        if(periodName == "TP 09")
        {
            return "18 jul - 24 jul"
        }
        if(periodName == "TP 10")
        {
            return "25 jul - 31 jul"
        }
        if(periodName == "TP 11")
        {
            return "1 aug - 7 aug"
        }
        if(periodName == "TP 12")
        {
            return "8 aug - 14 aug"
        }
        if(periodName == "TP 13")
        {
            return "15 aug - 21 aug"
        }
        if(periodName == "TP 14")
        {
            return "22 aug - 4 sep"
        }
        if(periodName == "TP 15")
        {
            return "5 sep - 16 okt"
        }
        return "17 okt - 31 dec"
    }
}