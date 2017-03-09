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
    func downloadHTML(_ callback:@escaping ([Tournament]) -> Void) {
        HttpDownloader().httpGetOld(baseURL + "terminliste.php?org=SVBF.SE.SVB&p=47"){
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
    
    func parseHTML(_ HTMLData:Data) -> [Tournament] {
        let error: NSError? = nil
        var allCells = TFHpple(htmlData: HTMLData).search(withXPathQuery: "//table//td")

        var tournaments = [Tournament]()
        if let error2 = error {
            print("Error : \(error2)")
        } else {
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "EEE, d MMM"
            dayTimePeriodFormatter.locale = Locale(identifier: "sv_SE")

            for t in 1 ..< (allCells?.count)!/7 
            {
                let startAt = t * 7
                let from = Date.parse(cleanValue(allCells?[startAt]))
                let level = cleanValue(allCells?[startAt+5])
                let name = cleanValue(allCells?[startAt+4])
                let link = getHref(allCells?[startAt+4])
                
                print("")
                
                let tournament = Tournament(
                    from: from,
                    formattedFrom: dayTimePeriodFormatter.string(from: from),
                    to: getDate(allCells?[startAt+1]),
                    period: getPeriodName(cleanValue(allCells?[startAt+2])),
                    organiser: cleanValue(allCells?[startAt+3]),
                    name: name,
                    level: level,
                    levelCategory: getLevelCategory(level.lowercased(), name: name),
                    type: cleanValue(allCells?[startAt+6]),
                    link: self.baseURL + (link as String),
                    moreInfo: link.characters.count > 0
                )
                tournaments.append(tournament)
            }
        }
        return tournaments
    }
    
    func getDate(_ value: Any) -> Foundation.Date{
        let date = cleanValue(value)
        if(date.isEmpty){
            return Foundation.Date()
        }
        //print("\(Date.parse("2017." + date))")
        return Date.parse("2017." + date)
    }
    
    func getLevelCategory(_ level:String, name:String) -> String{
        let name = name.lowercased()
        let level = level.lowercased()
        if(level == "veteran-sm" || level == "ungdoms-sm" || level == "mixed-sm" || level == "sm-slutspel" || name.range(of: "senior-sm") != nil) {
            return "sm"
        } else if(level == "mixed" || name.range(of: "mixed") != nil) {
            return "mixed"
        }
        else if(level == "open grön" || name.range(of: "grön") != nil) {
            return "open grön"
        }
        else if(level == "open svart" || name.range(of: "svart") != nil || name.range(of: "open") != nil) {
            return "open svart"
        }
        else if(level == "swedish beach tour" || level == "swedish beach tour final" || name.range(of: "swedish beach tour") != nil) {
            return "swedish beach tour"
        }
        else if(level == "challenger" || name.range(of: "challenger") != nil || name.range(of: "ch1") != nil || name.range(of: "ch2") != nil) {
            return "challenger"
        }
        return "övrigt"
    }
    
    func getPeriodName(_ shortSectionName:String) -> String {
        let range = TournamentListHelper().getDateRangeForPeriod(shortSectionName as NSString)
        
        if(shortSectionName == TournamentListHelper().getPeriodForDate(Foundation.Date()).name)
        {
            return shortSectionName + " (nuvarande, " + range + ")"
        }
        return shortSectionName + " (" + range + ")"
    }
    
    func getHref(_ element:Any) -> String{
        let tfElement = element as! TFHppleElement
        if(tfElement.attributes["href"] != nil) {
            return tfElement.attributes["href"] as! String
        }
        return tfElement.children
            .map({ self.getHref($0 as Any) })
            .filter({ $0.characters.count > 0 })
            .reduce(""){ $0 + $1}
    }
}

