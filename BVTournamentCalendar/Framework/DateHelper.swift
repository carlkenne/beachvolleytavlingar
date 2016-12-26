//
//  DateHelper.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 17/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class Date {
    
    class func from(year:Int, month:Int, day:Int) -> Foundation.Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        let gregorian = Calendar(identifier:Calendar.Identifier.gregorian)
        let date = gregorian.date(from: c)
        return date!
    }
    
    class func parse(_ dateStr:String, format:String="yyyy.MM.dd") -> Foundation.Date {
        
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone.current
        dateFmt.dateFormat = format
        return dateFmt.date(from: dateStr)!
    }
}
