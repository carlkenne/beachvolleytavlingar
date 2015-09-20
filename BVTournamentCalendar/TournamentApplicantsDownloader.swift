//
//  TournamentDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//



class TournamentApplicantsDownloader {
    func downloadHTML(tournament:Tournament, detail: TournamentDetail?, callback:([Applicants]) -> Void) {
        //renew the session
        
        if(detail != nil){
            self.setServerCookieRequest(detail!.setServerSessionCookieUrl, tournament: tournament, callback: callback)
        } else {
            TournamentDetailDownloader().downloadHTML(tournament) {
                (data) -> Void in
                sleep(1)
                self.setServerCookieRequest(data.setServerSessionCookieUrl, tournament: tournament, callback: callback)
            }
        }
    }
    
    func setServerCookieRequest(url: NSString,tournament:Tournament, callback:([Applicants]) -> Void) {
        HttpDownloader().httpGetOld("https://www.profixio.com" + (url as String)) {
             (data, error) -> Void in
            sleep(1)
            self.participantsDownload(tournament, callback:callback)
        }
    }
    
    func participantsDownload(tournament:Tournament, callback:([Applicants]) -> Void) {
        HttpDownloader().httpGetOld("https://www.profixio.com/pamelding/vis_paamelding.php") {
            (data, error) -> Void in
            if error != nil {
                print(error)
                callback([])
            } else {
                let results = self.parseHTML(tournament, HTMLData: data!)
                callback( results )
            }
        }
    }
    
    func parseHTML(tournament:Tournament, HTMLData:NSData) -> [Applicants] {
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("/html/body/table[1]//td")
        var results = [Applicants]()
        
        for var row = 0; row < (allCells.count-7)/8 ; row++ {
            let td = (row * 8)+7
            let applicants = Applicants(
                players: cleanValue(allCells[td]).removeAll("(Väntelista)").removeAll(" / Partner önskas"),
                club: cleanValue(allCells[td+1]),
                type: (cleanValue(allCells[td+2]) as String) + (getReserveCode(allCells[td]) as String),
                time: cleanValue(allCells[td+3]),
                rankingPoints: cleanValue(allCells[td+4]).removeAll("*"),
                entryPoints: cleanValue(allCells[td+5]).removeAll("*"),
                status: cleanValue(allCells[td+6]) == "OK"
            )
            results.append(applicants)
            //println(applicants.players)
        }
        return results
    }
    
    func getReserveCode(value:AnyObject) -> String {
        if( cleanValue(value).rangeOfString("Väntelista") != nil){
            return "V"
        }
        if( cleanValue(value).rangeOfString("önskas") != nil){
            return "Ö"
        }
        return ""
    }
    
    func cleanValue(value:AnyObject) -> String {
        var content = (value as! TFHppleElement).content
        

        content = content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                .stringByReplacingOccurrencesOfString("Ã¶", withString: "ö")
                .stringByReplacingOccurrencesOfString("Ã¥", withString: "å")
                .stringByReplacingOccurrencesOfString("Ã©", withString: "é")
                .stringByReplacingOccurrencesOfString("Ã", withString: "Ö")
                .stringByReplacingOccurrencesOfString("Ã", withString: "É")
                .stringByReplacingOccurrencesOfString("Ã¤", withString: "ä")

        content = content.removeOccurancesUTF16( 133)
        content = content.replaceOccurancesUTF16( 195, with: "Å")
        return content
        }
        

}