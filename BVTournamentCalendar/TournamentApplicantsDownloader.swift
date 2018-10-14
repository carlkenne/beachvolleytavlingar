//
//  TournamentDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

class TournamentApplicantsDownloader {
    func downloadHTML(_ tournament:Tournament, detail: TournamentDetail?, callback:@escaping ([Applicants]) -> Void) {
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
    
    func setServerCookieRequest(_ url: NSString, callback:@escaping ([Applicants]) -> Void) {
        HttpDownloader().httpGet("https://www.profixio.com" + (url as String)) {
             (data, error) -> Void in
            sleep(1)
            self.participantsDownload(callback)
        }
    }
    
    func participantsDownload(_ callback:@escaping ([Applicants]) -> Void) {
        HttpDownloader().httpGet("https://www.profixio.com/pamelding/vis_paamelding.php") {
            (data, error) -> Void in
            if error != nil {
                print(error!)
                callback([])
            } else {
                let results = self.parseHTML(data!)
                callback( results )
            }
        }
    }
    
    func parseHTML(_ HTMLData:Data) -> [Applicants] {
        var allCells = TFHpple(htmlData: HTMLData).search(withXPathQuery: "/html/body/table[1]//td") as [Any]
        var results = [Applicants]()
        let HTMLDataAsString = String(data: HTMLData, encoding: String.Encoding.ascii)
        
        for row in 0 ..< ((allCells.count)-7)/8  {
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
                type: cleanValue(allCells[td+2]) + getReserveCode(allCells[td]),
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
    
    func getReserveCode(_ value:Any) -> String {
        if( cleanValue(value).range(of: "Väntelista") != nil){
            return "V"
        }
        if( cleanValue(value).range(of: "önskas") != nil){
            return "Ö"
        }
        return ""
    }
    
    func getTeamId(_ value:Any) -> String {
        let raw = (value as! TFHppleElement).raw
        let id = raw?.getStringBetween("vis_spillerkontaktinfo(", end: ", event)")
        return id!
    }
    
    func getPlayers(_ raw: String, teamid: String) -> (rank1:String, rank2:String) {
        
        let teamData = raw.getStringBetween("[lag_id] => \(teamid)", end: "[entrysort] =>")
        let player1id = teamData.getStringBetween("[sp_id] => ", end: "[sp_navn]")
        //print("player 1 : \(player1id)")
        let lastPartOfTeamData = teamData.getStringBetween("[sp_navn]",end: "[ranksort]")
        let player2id = lastPartOfTeamData.getStringBetween("[sp_id] => ", end: "[sp_navn]")
        //print("player 2 : \(player2)")
        
        var rank1 = findRanking(raw, id: player1id);
        var rank2 = findRanking(raw, id: player2id);
    
        if((raw.range(of: "\(player1id) : 0")) != nil) {
            rank1 = "0"
        }
        if((raw.range(of: "\(player2id) : 0")) != nil) {
            rank2 = "0"
        }
        
        return (rank1: rank1,
                rank2: rank2)
    }
    
    func findRanking(_ str: String, id: String) -> String {
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
                return rank.replacingOccurrences(of: ".00", with: "");
            }
            
            iteratingString = iteratingString.substring(from: iteratingString.range(of: "[rankingpoints_max]")!.upperBound)
        }
    }
    
    func cleanValue(_ value:Any) -> String {
        var content = (value as! TFHppleElement).content
        //print(content)
        content = content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                .replacingOccurrences(of: "Ã¶", with: "ö")
                .replacingOccurrences(of: "Ã¥", with: "å")
                .replacingOccurrences(of: "Ã©", with: "é")
                .replacingOccurrences(of: "Ã", with: "Ö")
                .replacingOccurrences(of: "Ã", with: "É")
                .replacingOccurrences(of: "Ã¤", with: "ä")

        content = content?.removeOccurancesUTF16( 133)
        content = content?.replaceOccurancesUTF16( 195, with: "Å")
        return content!
    }
}
