//
//  PlayerRankingGameListDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 17/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class PlayerRankingGameListDownloader : DownloaderBase {
    func downloadHTML(detailsUrl:String, callback:(PlayerRankingDetails) -> Void) {
        //renew the session
        
        HttpDownloader().httpGetOld("https://www.profixio.com/fx/ranking_beach/index.php"){
            (data) -> Void in
            sleep(1)
            
            HttpDownloader().httpPost("https://www.profixio.com/fx/ranking_beach/visrank_detaljer.php", bodyData: detailsUrl) {
                (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    let results = self.parseHTML(data!)
                    callback( results )
                }
            }
        }
    }
    
    func createRanking(index: Int, allCells: [AnyObject], isEntryPoint : Bool) -> PlayerRankingGame {
        let name = cleanValue(allCells[index+2])
        let levelCategory = TournamentsDownloader().getLevelCategory("", name: name)
        print("\(name) \(isEntryPoint)")
        
        return PlayerRankingGame(
            period: cleanValue(allCells[index]),
            year: cleanValue(allCells[index+1]),
            name: name,
            points: Int(cleanValue(allCells[index+3]).removeAll(".00"))!,
            result: cleanValue(allCells[index+4])
                .stringByReplacingOccurrencesOfString("(H)", withString: "?")
                .stringByReplacingOccurrencesOfString("(D)", withString: "?")
                .removeAll("(H - ")
                .removeAll("(D - ")
                .removeAll("(M - ")
                .removeAll(")")
                .removeAll("("),
            levelCategory: levelCategory,
            isEntryPoint: isEntryPoint
        )
    }
    
    func parseHTML(HTMLData:NSData) -> PlayerRankingDetails {
        
        print(String(data: HTMLData, encoding: NSUTF8StringEncoding))
        let entryPoints = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//tr[contains(@id,\"ep_20\")]//td")
        
        let others = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//tr[not(contains(@id,\"ep_20\"))]//td")
        var results = [PlayerRankingGame]()
        
        for row in 0 ..< (entryPoints.count)/5  {
            results.append(self.createRanking((row * 5), allCells: entryPoints, isEntryPoint: true))
        }
        
        for row in 0 ..< (others.count)/5  {
            results.append(self.createRanking((row * 5), allCells: others, isEntryPoint: false))
        }
        let age = getAge(HTMLData);
        print(age)
        return PlayerRankingDetails(games: results,
                                    age: age)
    }
    
    func getAge(HTMLData:NSData) -> Int {
        
        let nameRow = cleanValue(TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//b")[0])
        let ageCode = nameRow.componentsSeparatedByString("(")[1]
            .componentsSeparatedByString(")")[0]
        print(ageCode)
        if(ageCode.containsString("-") ){
            
            let bornDateFormatter = NSDateFormatter()
            bornDateFormatter.dateFormat = "YYYY-MM-DD"
            let bornDate = bornDateFormatter.dateFromString(ageCode)
            return getYearsBetween(bornDate!, to: NSDate())
        } else if(ageCode.hasPrefix("M") || ageCode.hasPrefix("W")) {
            let myNSString = ageCode as NSString
            let ageString = myNSString.substringWithRange(NSRange(location: 1, length: 6))
            let bornDateFormatter = NSDateFormatter()
            bornDateFormatter.dateFormat = "DDMMYY"
            let bornDate = bornDateFormatter.dateFromString(ageString)
            return getYearsBetween(bornDate!, to: NSDate())
        }
        return 0
    }
    
    func getYearsBetween(from: NSDate, to: NSDate) -> Int {
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: from, toDate: to, options: NSCalendarOptions.init(rawValue: 0))
        print(diffDateComponents.month)
        print(diffDateComponents.day)
        return diffDateComponents.year
        
    }
}