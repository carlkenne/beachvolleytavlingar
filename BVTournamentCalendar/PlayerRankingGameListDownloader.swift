//
//  PlayerRankingGameListDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 17/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class PlayerRankingGameListDownloader {
    func downloadHTML(detailsUrl:String, callback:([PlayerRankingGame]) -> Void) {
        //renew the session
        
        HttpDownloader().httpGetOld("http://www.profixio.com/fx/ranking_beach/index.php"){
            (data) -> Void in
            sleep(1)
            
            HttpDownloader().httpPost("http://www.profixio.com/fx/ranking_beach/visrank_detaljer.php", bodyData: detailsUrl) {
                (data, error) -> Void in
                if error != nil {
                    println(error)
                } else {
                    var results = self.parseHTML(data!)
                    callback( results )
                }
            }
        }
    }
    
    func createRanking(index: Int, allCells: [AnyObject], isEntryPoint : Bool) -> PlayerRankingGame {
        var name = cleanValue(allCells[index+2])
        var levelCategory = TournamentsDownloader().getLevelCategory("", name: name)
        println("\(name) \(isEntryPoint)")
        
        return PlayerRankingGame(
            period: cleanValue(allCells[index]),
            year: cleanValue(allCells[index+1]),
            name: name,
            points: cleanValue(allCells[index+3]).removeAll(".00").toInt()!,
            result: cleanValue(allCells[index+4])
                .stringByReplacingOccurrencesOfString("(H)", withString: "okänd")
                .stringByReplacingOccurrencesOfString("(D)", withString: "okänd")
                .removeAll("(H - ")
                .removeAll("(D - ")
                .removeAll("(M - ")
                .removeAll(")")
                .removeAll("("),
            levelCategory: levelCategory,
            isEntryPoint: isEntryPoint
        )
    }
    
    func parseHTML(HTMLData:NSData) -> [PlayerRankingGame] {
        
        var entryPoints = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//tr[contains(@id,\"ep_20\")]//td")
        var others = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//tr[not(contains(@id,\"ep_20\"))]//td")
        var results = [PlayerRankingGame]()
        println(entryPoints.count/5)
        println(others.count/5)
        
        for var row = 0; row < (entryPoints.count)/5 ; row++ {
            results.append(self.createRanking((row * 5), allCells: entryPoints, isEntryPoint: true))
        }
        
        for var row = 0; row < (others.count)/5 ; row++ {
            results.append(self.createRanking((row * 5), allCells: others, isEntryPoint: false))
        }
        
        /*
        var datastring = NSString(data: HTMLData, encoding: NSUTF8StringEncoding)
        var str = String(datastring!).stringByReplacingOccurrencesOfString("ep_array[", withString: "€")
        var epoints = split(str) { $0 == "€" }
        
        for var ep = 1; ep < (epoints.count); ep++ {
            var epParts = split(epoints[ep]){ $0 == "'" }
            
            if(epParts.count > 1) {
                var entryPointId = epParts[1]
                println(entryPointId)
            }
        }*/
        
        return results
    }
    
    func cleanValue(value:AnyObject) -> String {
        
        return (value as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            .stringByReplacingOccurrencesOfString("ZoumlZ", withString: "ö")
            .stringByReplacingOccurrencesOfString("ZOumlZ", withString: "Ö")
            .stringByReplacingOccurrencesOfString("ZaumlZ", withString: "ä")
            .stringByReplacingOccurrencesOfString("ZAumlZ", withString: "ä")
            .stringByReplacingOccurrencesOfString("ZaringZ", withString: "å")
            .stringByReplacingOccurrencesOfString("ZAringZ", withString: "Å")
    }
}

