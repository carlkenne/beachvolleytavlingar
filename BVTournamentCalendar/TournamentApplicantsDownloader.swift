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
            if (detail!.setServerSessionCookieUrl == "") {
                callback([Applicants]());
            } else {
                self.setServerCookieRequest(detail!.setServerSessionCookieUrl, callback: callback)
            }
        } else {
            TournamentDetailDownloader().downloadHTML(tournament) {
                (data) -> Void in
                sleep(1)
                self.setServerCookieRequest(data.setServerSessionCookieUrl, callback: callback)
            }
        }
    }
    
    func setServerCookieRequest(url: NSString, callback:([Applicants]) -> Void) {
        HttpDownloader().httpGetOld("https://www.profixio.com" + (url as String)) {
             (data, error) -> Void in
            sleep(1)
            self.participantsDownload(callback)
        }
    }
    
    func participantsDownload(callback:([Applicants]) -> Void) {
        HttpDownloader().httpGetOld("https://www.profixio.com/pamelding/vis_paamelding.php") {
            (data, error) -> Void in
            if error != nil {
                print(error)
                callback([])
            } else {
                let results = self.parseHTML(data!)
                callback( results )
            }
        }
    }
    
    func parseHTML(HTMLData:NSData) -> [Applicants] {
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("/html/body/table[1]//td")
        var results = [Applicants]()
        let HTMLDataAsString = String(data: HTMLData, encoding: NSASCIIStringEncoding)
        
        for row in 0 ..< (allCells.count-7)/8  {
            let td = (row * 8)+7
            let teamid = getTeamId(allCells[td])
            var player1Ranking = "";
            var player2Ranking = "";
            
            if(HTMLDataAsString != nil){
                let ranking = getPlayers(HTMLDataAsString!, teamid: teamid)
                player1Ranking = ranking.rank1
                player2Ranking = ranking.rank2
            }
            
            let applicants = Applicants(
                players: cleanValue(allCells[td]).removeAll("(Väntelista)").removeAll(" / Partner önskas"),
                club: cleanValue(allCells[td+1]),
                type: (cleanValue(allCells[td+2]) as String) + (getReserveCode(allCells[td]) as String),
                time: cleanValue(allCells[td+3]),
                rankingPoints: cleanValue(allCells[td+4]).removeAll("*"),
                entryPoints: cleanValue(allCells[td+5]).removeAll("*"),
                status: cleanValue(allCells[td+6]) == "OK",
                player1Ranking: player1Ranking,
                player2Ranking: player2Ranking
            )
            
            results.append(applicants)
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
    
    func getTeamId(value:AnyObject) -> String {
        let raw = (value as! TFHppleElement).raw
        let id = raw.getStringBetween("vis_spillerkontaktinfo(", end: ", event)")
        //print(id)
        return id
    }
    
    func getPlayers(raw: String, teamid: String) -> (rank1:String, rank2:String) {
        
        let teamData = raw.getStringBetween("[lag_id] => \(teamid)", end: "[entrysort] =>")
        let player1id = teamData.getStringBetween("[sp_id] => ", end: "[sp_navn]")
        //print("player 1 : \(player1id)")
        let lastPartOfTeamData = teamData.getStringBetween("[sp_navn]",end: "[ranksort]")
        let player2id = lastPartOfTeamData.getStringBetween("[sp_id] => ", end: "[sp_navn]")
        //print("player 2 : \(player2)")
        
        var rank1 = findRanking(raw, id: player1id);
        var rank2 = findRanking(raw, id: player2id);
    
        if((raw.rangeOfString("\(player1id) : 0")) != nil) {
            rank1 = "0"
        }
        if((raw.rangeOfString("\(player2id) : 0")) != nil) {
            rank2 = "0"
        }
        
        return (rank1: rank1,
                rank2: rank2)
    }
    
    func findRanking(str: String, id: String) -> String {
        if(id == "-1") {
            return ""
        }
        var iteratingString = str;
        
        while(true) {
            let section = iteratingString.getStringBetween("[rankingpoints]", end:"[rankingpoints_max]")
            if(section == "") {
                return "";
            }
            
            let rank = section.getStringBetween("[\(id)] => ", end: "\n")
            if(rank != "") {
                return rank.stringByReplacingOccurrencesOfString(".00", withString: "");
            }
            
            iteratingString = iteratingString.substringFromIndex(iteratingString.rangeOfString("[rankingpoints_max]")!.endIndex)
        }
    }
    
    func cleanValue(value:AnyObject) -> String {
        var content = (value as! TFHppleElement).content
        //print(content)
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