//
//  PlayerRankingGameListDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 17/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class PlayerRankingGameListDownloader : DownloaderBase {
    func downloadHTML(detailsUrl:String, callback:([PlayerRankingGame]) -> Void) {
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
        
        let entryPoints = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//tr[contains(@id,\"ep_20\")]//td")
        let others = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//tr[not(contains(@id,\"ep_20\"))]//td")
        var results = [PlayerRankingGame]()
        print(entryPoints.count/5)
        print(others.count/5)
        
        for var row = 0; row < (entryPoints.count)/5 ; row++ {
            results.append(self.createRanking((row * 5), allCells: entryPoints, isEntryPoint: true))
        }
        
        for var row = 0; row < (others.count)/5 ; row++ {
            results.append(self.createRanking((row * 5), allCells: others, isEntryPoint: false))
        }
        
        return results
    }
    

}

