//
//  TournamentsDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 28/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class TournamentsDownloader {
    let baseURL = "http://www.profixio.com/fx/"
    func downloadHTML(callback:([Tournament]) -> Void) {
        HttpDownloader().httpGetOld(baseURL + "terminliste.php?org=SVBF.SE.SVB&p=36"){
            (data, error) -> Void in
            if error != nil {
                println(error)
                callback([])
            } else {
                var results = self.parseHTML(data!)
                callback(results)
            }
        }
    }
    
    func parseHTML(HTMLData:NSData) -> [Tournament] {
        var error: NSError?
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table//td")

        var tournaments = [Tournament]()
        if let error = error {
            println("Error : \(error)")
        } else {
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "EEE, d MMM"
            dayTimePeriodFormatter.locale = NSLocale(localeIdentifier: "sv_SE")

            for var t = 1; t < allCells.count/7 ; t++
            {
                let startAt = t * 7
                var cell = allCells[startAt+4] as! TFHppleElement
                let from = Date.parse(cleanValue(allCells[startAt]))
                let level = cleanValue(allCells[startAt+5])
                let name = cleanValue(allCells[startAt+4])
                let link = getHref(allCells[startAt+4])
                
                let tournament = Tournament(
                    from: from,
                    formattedFrom: dayTimePeriodFormatter.stringFromDate(from),
                    to: getDate(allCells[startAt+1]),
                    period: getPeriodName(cleanValue(allCells[startAt+2])),
                    organiser: cleanValue(allCells[startAt+3]),
                    name: name,
                    level: level,
                    levelCategory: getLevelCategory(level.lowercaseString, name: name.lowercaseString),
                    type: cleanValue(allCells[startAt+6]),
                    link: self.baseURL + (link as String),
                    moreInfo: count(link) > 0
                )
                tournaments.append(tournament)
            }
        }
        return tournaments
    }
    
    func getDate(value: AnyObject) -> NSDate{
        var date = cleanValue(value)
        if(date.isEmpty){
            return NSDate()
        }
        
        return Date.parse("2015." + date)
    }
    
    func getLevelCategory(level:String, name:String) -> String{
        if(level == "mixed" || name.rangeOfString("mixed") != nil){
            return "mixed"
        }
        else if(level == "open grön" || name.rangeOfString("grön") != nil){
            return "open grön"
        }
        else if(level == "open svart" || name.rangeOfString("svart") != nil || name.rangeOfString("open") != nil){
            return "open svart"
        }
        else if(level == "swedish beach tour"){
            return "swedish beach tour"
        }
        else if(level == "challenger" || name.rangeOfString("challenger") != nil || name.rangeOfString("ch1") != nil || name.rangeOfString("ch2") != nil){
            return "challenger"
        }
        return "misc"
    }
    
    func getPeriodName(shortSectionName:String) -> String {
        var periods = TournamentPeriods()
        var range = periods.getDateRangeForPeriod(shortSectionName)
        
        if(shortSectionName == periods.getPeriodNameForDate(NSDate()))
        {
            return shortSectionName + " (nuvarande, " + range + ")"
        }
        return shortSectionName + " (" + range + ")"
    }
    
    func getHref(element:AnyObject) -> String{
        var tfElement = element as! TFHppleElement
        if(tfElement.attributes["href"] != nil) {
            return tfElement.attributes["href"] as! String
        }
        return tfElement.children
            .map({ self.getHref($0) })
            .filter({ count($0) > 0 })
            .reduce(""){ $0 + $1}
    }
    
    func cleanValue(value:AnyObject) -> String {
        return (value as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

