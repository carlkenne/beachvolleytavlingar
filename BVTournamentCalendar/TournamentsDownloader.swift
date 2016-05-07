//
//  TournamentsDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 28/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class TournamentsDownloader : DownloaderBase {
    let baseURL = "https://www.profixio.com/fx/"
    func downloadHTML(callback:([Tournament]) -> Void) {
        HttpDownloader().httpGetOld(baseURL + "terminliste.php?org=SVBF.SE.SVB&p=40"){
            (data, error) -> Void in
            if error != nil {
                print(error)
                callback([])
            } else {
                let results = self.parseHTML(data!)
                callback(results)
            }
        }
    }
    
    func parseHTML(HTMLData:NSData) -> [Tournament] {
        let error: NSError? = nil
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table//td")

        var tournaments = [Tournament]()
        if let error2 = error {
            print("Error : \(error2)")
        } else {
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "EEE, d MMM"
            dayTimePeriodFormatter.locale = NSLocale(localeIdentifier: "sv_SE")

            for t in 1 ..< allCells.count/7 
            {
                let startAt = t * 7
                let from = Date.parse(cleanValue(allCells[startAt]))
                let level = cleanValue(allCells[startAt+5])
                let name = cleanValue(allCells[startAt+4])
                let link = getHref(allCells[startAt+4])
                
                print("")
                
                let tournament = Tournament(
                    from: from,
                    formattedFrom: dayTimePeriodFormatter.stringFromDate(from),
                    to: getDate(allCells[startAt+1]),
                    period: getPeriodName(cleanValue(allCells[startAt+2])),
                    organiser: cleanValue(allCells[startAt+3]),
                    name: name,
                    level: level,
                    levelCategory: getLevelCategory(level.lowercaseString, name: name),
                    type: cleanValue(allCells[startAt+6]),
                    link: self.baseURL + (link as String),
                    moreInfo: link.characters.count > 0
                )
                tournaments.append(tournament)
            }
        }
        return tournaments
    }
    
    func getDate(value: AnyObject) -> NSDate{
        let date = cleanValue(value)
        if(date.isEmpty){
            return NSDate()
        }
        
        return Date.parse("2016." + date)
    }
    
    func getLevelCategory(level:String, name:String) -> String{
        let name = name.lowercaseString
        if(level == "mixed" || name.rangeOfString("mixed") != nil){
            return "mixed"
        }
        else if(level == "open grön" || name.rangeOfString("grön") != nil){
            return "open grön"
        }
        else if(level == "open svart" || name.rangeOfString("svart") != nil || name.rangeOfString("open") != nil){
            return "open svart"
        }
        else if(level == "swedish beach Ttur" || level == "swedish beach tour final" || name.rangeOfString("swedish beach tour") != nil){
            return "swedish beach tour"
        }
        else if(level == "Veteran-SM" || level == "Ungdoms-SM" || level == "Mixed-SM" || level == "SM-slutspel" || name.rangeOfString("senior-sm") != nil){
            return "sm"
        }
        else if(level == "challenger" || name.rangeOfString("challenger") != nil || name.rangeOfString("ch1") != nil || name.rangeOfString("ch2") != nil){
            return "challenger"
        }
        return "övrigt"
    }
    
    func getPeriodName(shortSectionName:String) -> String {
        let periods = TournamentPeriods()
        let range = periods.getDateRangeForPeriod(shortSectionName)
        
        if(shortSectionName == periods.getPeriodNameForDate(NSDate()))
        {
            return shortSectionName + " (nuvarande, " + range + ")"
        }
        return shortSectionName + " (" + range + ")"
    }
    
    func getHref(element:AnyObject) -> String{
        let tfElement = element as! TFHppleElement
        if(tfElement.attributes["href"] != nil) {
            return tfElement.attributes["href"] as! String
        }
        return tfElement.children
            .map({ self.getHref($0) })
            .filter({ $0.characters.count > 0 })
            .reduce(""){ $0 + $1}
    }
}

