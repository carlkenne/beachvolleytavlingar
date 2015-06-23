//
//  TournamentDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class TournamentDownloader {
    
    func downloadHTML(tournament:Tournament, callback:(TournamentDetail) -> Void) {
        //renew the session
        
        TournamentsDownloader().downloadHTML(){ (data) -> Void in
            sleep(1)
            self.delayedDownload(tournament, callback: callback)
        }
    }
    
    func delayedDownload(tournament:Tournament, callback:(TournamentDetail) -> Void) {
        HttpDownloader().httpGetOld(tournament.link){
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                var results = self.parseHTML(tournament, HTMLData: data!)
                callback(results)
            }
        }
        
    }
    
    func parseHTML(tournament:Tournament, HTMLData:NSData) -> TournamentDetail {
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table")
        var anmalan = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//input[@value='Anmälan']")
        return TournamentDetail(
            link: tournament.link,
            table: (allCells[1] as TFHppleElement).raw.stringByReplacingOccurrencesOfString("Kontaktinformation", withString: "Kontakt information"),
            redirectURL: self.extractOnClickLink((anmalan[0] as TFHppleElement).attributes["onclick"] as NSString))
    }
    
    func extractOnClickLink(onclickString: NSString) -> NSString {
        var str = onclickString.stringByReplacingOccurrencesOfString("window.open(\"..", withString: "")
        str = str.stringByReplacingOccurrencesOfString("\", \"_blank\")", withString: "")
        return str
    }
    
    func cleanValue(value:AnyObject) -> String {
        return (value as TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}