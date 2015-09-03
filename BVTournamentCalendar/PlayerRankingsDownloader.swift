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
        
        HttpDownloader().httpGetOld("http://www.profixio.com/fx/ranking_beach/index.php") {
            (data) -> Void in
            sleep(1)
            
            HttpDownloader().httpGetOld("http://www.profixio.com/fx/ranking_beach/visrank.php?k="+type) {
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
    
    func parseHTML(HTMLData:NSData) -> [PlayerRanking] {
        
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table[2]//tr/td")
        var results = [PlayerRanking]()
        
        for var row = 1; row < (allCells.count)/5 ; row++ {
            var td = (row * 5)
            if(cleanValue(allCells[td]) == "Spelare utan licens"){ //after this point the table is completly different
                
                results.sort({ $0.entryPoints > $1.entryPoints })
                results[0].rankByEntryPoints = 1
                for var res = 1; res < (results.count); res++ {
                    if(results[res].entryPoints == results[res-1].entryPoints){
                        results[res].rankByEntryPoints = results[res-1].rankByEntryPoints
                    } else {
                        results[res].rankByEntryPoints = res+1
                    }
                }
                
                return results
            }
            var ranking = PlayerRanking(
                rankByPoints: cleanValue(allCells[td]).toInt()!,
                rankByEntryPoints: 0,
                name: cleanValue(allCells[td+1]),
                club: cleanValue(allCells[td+2]),
                points: cleanValue(allCells[td+3]).toInt()!,
                entryPoints: cleanValue(allCells[td+4]).toInt()!,
                detailsUrl: getRankingDetailUrl(allCells[td+1]) //"rand=0.7901839658152312&spid=8728&klasse=H&tp="
            )
            
            results.append(ranking)
            
           
        }
        
        return results
    }
    
    func cleanValue(value:AnyObject) -> String {
        return (value as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func getAttribute(value:AnyObject, name: String) -> String {
        var child = (value as! TFHppleElement).children[0] as! TFHppleElement
        return child.attributes[name]! as! String
    }
    
    func getRankingDetailUrl(value:AnyObject) -> String {
        var str = getAttribute(value, name: "onclick")
        str = str.stringByReplacingOccurrencesOfString("vis_rankdetaljer(", withString: "")
        str = str.stringByReplacingOccurrencesOfString(", '', event)", withString: "")
        str = str.stringByReplacingOccurrencesOfString("'", withString: "")
        str = str.stringByReplacingOccurrencesOfString(" ", withString: "")
        var both = split(str) {$0 == ","}
        return "rand=0.7901839658152312&spid=\(both[0])&klasse=\(both[1])&tp="
    }
}


