//
//  TournamentDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class TournamentDownloader {
    var t:Tournament? = nil
    var c:((TournamentDetail) -> Void)? = nil
    
    
    func downloadHTML(tournament:Tournament, callback:(TournamentDetail) -> Void) {
        //renew the session
        t = tournament
        c = callback
        
        TournamentsDownloader().downloadHTML(){ (data) -> Void in
            sleep(1)
            //var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: NSSelectorFromString("delayedDownload"), userInfo: nil, repeats: true)
            self.delayedDownload()
        }
    }
    
    func delayedDownload() {
        HttpDownloader().httpGetOld(t!.link){
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                var results = self.parseHTML(self.t!, HTMLData: data!)
                self.c!(results)
            }
        }
        
    }
    
    func parseHTML(tournament:Tournament, HTMLData:NSData) -> TournamentDetail {
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table")
        return TournamentDetail(link: tournament.link, table: (allCells[1] as TFHppleElement).raw)
    }
    
    func cleanValue(value:AnyObject) -> String {
        return (value as TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}