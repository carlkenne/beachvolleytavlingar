//
//  PlayerRankingGameListDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 17/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class PlayerRankingGameListDownloader : DownloaderBase {
    func downloadHTML(_ detailsUrl:String, callback:@escaping (PlayerRankingDetails) -> Void) {
        //renew the session
        
        HttpDownloader().httpGet("https://www.profixio.com/fx/ranking_beach/index.php"){
            (data, args)  -> Void in
            sleep(1)
            
            HttpDownloader().httpPost("https://www.profixio.com/fx/ranking_beach/visrank_detaljer.php", bodyData: detailsUrl) {
                (data, error) -> Void in
                if error != nil {
                    //print(error)
                } else {
                    let results = self.parseHTML(data!)
                    callback( results )
                }
            }
        }
    }
    
    func createRanking(_ index: Int, allCells: [AnyObject], isEntryPoint : Bool) -> PlayerRankingGame {
        let name = cleanValue(allCells[index+2])
        let levelCategory = TournamentsDownloader().getLevelCategory("", name: name)
        //print("\(name) \(isEntryPoint)")
        
        return PlayerRankingGame(
            period: cleanValue(allCells[index]),
            periodInt: periodToInt(cleanValue(allCells[index])),
            year: cleanValue(allCells[index+1]),
            name: name,
            points: Int(cleanValue(allCells[index+3]).removeAll(".00"))!,
            result: cleanValue(allCells[index+4])
                .replacingOccurrences(of: "(H)", with: "?")
                .replacingOccurrences(of: "(D)", with: "?")
                .removeAll("(H - ")
                .removeAll("(D - ")
                .removeAll("(M - ")
                .removeAll(")")
                .removeAll("("),
            levelCategory: levelCategory,
            isEntryPoint: isEntryPoint
        )
    }
    
    func periodToInt(_ period:String) -> Int {
        let p = period.replacingOccurrences(of: "TP", with: "")
        return Int(p)!;
    }
    
    func parseHTML(_ HTMLData:Data) -> PlayerRankingDetails {
        
        //print(String(data: HTMLData, encoding: NSUTF8StringEncoding))
        let entryPoints = TFHpple(htmlData: HTMLData).search(withXPathQuery: "//tr[contains(@id,\"ep_20\")]//td")
        
        let others = TFHpple(htmlData: HTMLData).search(withXPathQuery: "//tr[not(contains(@id,\"ep_20\"))]//td")
        var results = [PlayerRankingGame]()
        
        for row in 0 ..< (entryPoints?.count)!/5  {
            results.append(self.createRanking((row * 5), allCells: entryPoints! as [AnyObject], isEntryPoint: true))
        }
        
        for row in 0 ..< (others?.count)!/5  {
            results.append(self.createRanking((row * 5), allCells: others! as [AnyObject], isEntryPoint: false))
        }
        let age = getAge(HTMLData);
        print(age)
        return PlayerRankingDetails(games: results,
                                    age: age)
    }
    
    func getAge(_ HTMLData:Data) -> Int {
        
        let nameRow = cleanValue(TFHpple(htmlData: HTMLData).search(withXPathQuery: "//b")![0] as AnyObject)
        let ageCode = nameRow.components(separatedBy: "(")[1]
            .components(separatedBy: ")")[0]
        print(ageCode)
        if(ageCode.contains("-") ){
            
            let bornDateFormatter = DateFormatter()
            bornDateFormatter.dateFormat = "YYYY-MM-DD"
            let bornDate = bornDateFormatter.date(from: ageCode)
            return getYearsBetween(bornDate!, to: Foundation.Date())
        } else if(ageCode.hasPrefix("M") || ageCode.hasPrefix("K")) {
            let myNSString = ageCode as NSString
            let ageString = myNSString.substring(with: NSRange(location: 1, length: 6))
            let bornDateFormatter = DateFormatter()
            bornDateFormatter.dateFormat = "DDMMYY"
            let bornDate = bornDateFormatter.date(from: ageString)
            return getYearsBetween(bornDate!, to: Foundation.Date())
        }
        return 0
    }
    
    func getYearsBetween(_ from: Foundation.Date, to: Foundation.Date) -> Int {
        let diffDateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: from, to: to, options: NSCalendar.Options.init(rawValue: 0))
        //print(diffDateComponents.month)
        //print(diffDateComponents.day)
        return diffDateComponents.year!
        
    }
}
