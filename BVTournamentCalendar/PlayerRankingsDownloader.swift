//
//  PlayerRankingDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 13/07/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class PlayerRankingsDownloader {
    func downloadHTML(type:String, callback:([PlayerRanking]) -> Void) {
        //renew the session
        
        HttpDownloader().httpGetOld("https://www.profixio.com/fx/ranking_beach/index.php") {
            (data) -> Void in
            sleep(1)
            
            HttpDownloader().httpGetOld("https://www.profixio.com/fx/ranking_beach/visrank.php?k="+type) {
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
    
    func parseHTML(HTMLData:NSData) -> [PlayerRanking] {
        
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table[2]//tr/td")
        var results = [PlayerRanking]()
        
        for row in 1 ..< (allCells.count)/5  {
            let td = (row * 5)
            if(cleanValue(allCells[td]) == "Spelare utan licens"){ //after this point the table is completly different
                
                results.sortInPlace({ $0.entryPoints > $1.entryPoints })
                results[0].rankByEntryPoints = 1
                for res in 1 ..< (results.count) {
                    if(results[res].entryPoints == results[res-1].entryPoints){
                        results[res].rankByEntryPoints = results[res-1].rankByEntryPoints
                    } else {
                        results[res].rankByEntryPoints = res+1
                    }
                }
                
                return results
            }
            let ranking = PlayerRanking(
                rankByPoints: Int(cleanValue(allCells[td]))!,
                rankByEntryPoints: 0,
                name: cleanValue(allCells[td+1]),
                club: cleanValue(allCells[td+2]),
                points: Int(cleanValue(allCells[td+3]))!,
                entryPoints: Int(cleanValue(allCells[td+4]))!,
                detailsUrl: getRankingDetailUrl(allCells[td+1]), //"rand=0.7901839658152312&spid=8728&klasse=H&tp="
                id: 1
            )
            
            results.append(ranking)
        }
        
        return results
    }
    
    func cleanValue(value:AnyObject) -> String {
        return (value as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func getAttribute(value:AnyObject, name: String) -> String {
        let child = (value as! TFHppleElement).children[0] as! TFHppleElement
        return child.attributes[name]! as! String
    }
    
    func getRankingDetailUrl(value:AnyObject) -> String {
        var str = getAttribute(value, name: "onclick")
        str = str.stringByReplacingOccurrencesOfString("vis_rankdetaljer(", withString: "")
        str = str.stringByReplacingOccurrencesOfString(", '', event)", withString: "")
        str = str.stringByReplacingOccurrencesOfString("'", withString: "")
        str = str.stringByReplacingOccurrencesOfString(" ", withString: "")
        var both = str.characters.split {$0 == ","}.map { String($0) }
        return "rand=0.7901839658152312&spid=\(both[0])&klasse=\(both[1])&tp="
    }
}


