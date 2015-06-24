//
//  TournamentDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class TournamentDetailDownloader {
    var retries = 1
    
    func downloadHTML(tournament:Tournament, callback:(TournamentDetail) -> Void) {
        HttpDownloader().httpGetOld(tournament.link as String){
            (data, error) -> Void in
            if (error != nil) {
                println(error)
                callback(self.createFailedResponse(tournament))
            } else {
                if(self.areWeStillLoggedIn(data!) == true) {
                    var results = self.parseHTML(tournament, HTMLData: data!)
                    callback(results)
                }
                else {
                    self.retries = self.retries - 1
                    if(self.retries < 0){
                        callback(self.createFailedResponse(tournament))
                    }
                    else {
                        //renewing the session by calling the list again
                        TournamentsDownloader().downloadHTML(){ (data) -> Void in
                            sleep(1)
                            self.downloadHTML(tournament, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
    func createFailedResponse(tournament: Tournament) -> TournamentDetail{
        return TournamentDetail(
            link: tournament.link,
            table: "Could not get any information, please try again later.",
            setServerSessionCookieUrl: ""
        )
    }
    
    func areWeStillLoggedIn(HTMLData:NSData) -> Bool {
        return TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//h4[contains(.,'Gjestetilgang')]").count == 0
    }
    
    func parseHTML(tournament:Tournament, HTMLData:NSData) -> TournamentDetail {
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table")
        var anmalan = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//input[@value='Anmälan']")
        return TournamentDetail(
            link: tournament.link,
            table: (allCells[1] as! TFHppleElement).raw.stringByReplacingOccurrencesOfString("Kontaktinformation", withString: "Kontakt information"),
            setServerSessionCookieUrl: self.extractOnClickLink((anmalan[0] as! TFHppleElement).attributes["onclick"] as! NSString))
    }
    
    func extractOnClickLink(onclickString: NSString) -> NSString {
        var str = onclickString.stringByReplacingOccurrencesOfString("window.open(\"..", withString: "")
        str = str.stringByReplacingOccurrencesOfString("\", \"_blank\")", withString: "")
        return str
    }
    
    func cleanValue(value:AnyObject) -> String {
        return (value as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}