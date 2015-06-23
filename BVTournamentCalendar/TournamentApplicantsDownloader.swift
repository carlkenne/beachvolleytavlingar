//
//  TournamentDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//


class TournamentApplicantsDownloader {
    func downloadHTML(tournament:Tournament, callback:([Applicants]) -> Void) {
        //renew the session

        TournamentDownloader().downloadHTML(tournament) {
            (data) -> Void in
            sleep(1)
            self.redirectDownload(data.redirectURL, tournament: tournament, callback: callback)
        }
    }
    
    func redirectDownload(url: NSString,tournament:Tournament, callback:([Applicants]) -> Void) {
        HttpDownloader().httpGetOld("http://www.profixio.com" + (url as String)) {
             (data, error) -> Void in
            sleep(1)
            self.participantsDownload(tournament, callback:callback)
            
        }
    }
    
    func participantsDownload(tournament:Tournament, callback:([Applicants]) -> Void) {
        HttpDownloader().httpGetOld("http://www.profixio.com/pamelding/vis_paamelding.php") {
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                var results = self.parseHTML(tournament, HTMLData: data!)
                callback( results )
            }
        }
    }
    
    func parseHTML(tournament:Tournament, HTMLData:NSData) -> [Applicants] {
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("/html/body/table[1]//td")
        var results = [Applicants]()
        
        for var row = 0; row < (allCells.count-7)/8 ; row++ {
            var td = (row * 8)+7
            var applicants = Applicants(
                players: cleanValue(allCells[td]).stringByReplacingOccurrencesOfString("(Väntelista)", withString: ""),
                club: cleanValue(allCells[td+1]),
                type: (cleanValue(allCells[td+2]) as String) + (getReserveCode(allCells[td]) as String),
                time: cleanValue(allCells[td+3]),
                rankingPoints: cleanValue(allCells[td+4]),
                entryPoints: cleanValue(allCells[td+5]),
                status: cleanValue(allCells[td+6]).isEqualToString("OK")
            )

            results.append(applicants)
        }
        
        return results
    }
    
    func getReserveCode(value:AnyObject) -> NSString {
        if( cleanValue(value).containsString("Väntelista")){
            return "V"
        }
        return ""
    }
    
    func cleanValue(value:AnyObject) -> NSString {
        return (value as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}