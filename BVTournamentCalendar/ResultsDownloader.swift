//
//  ResultsDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 06/05/16.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import Foundation

struct Results {
    let HTML: String
    let hasResults: Bool
}

class ResultsDownloader {
    func downloadHTML(_ detail: TournamentDetail?, klass:String, callback:@escaping (Results) -> Void) {
        resultsDownload(detail!, klass:klass, callback: callback);
    }
    
    func resultsDownload(_ tournament:TournamentDetail, klass:String, callback:@escaping (Results) -> Void) {
        print(tournament.resultatLink)
        HttpDownloader().httpGetOld(tournament.resultatLink) {
            (data, error) -> Void in
            if error != nil {
                print(error)
                callback(Results(HTML: "<br/>Resultat ej tillgängligt", hasResults: false))
            } else {
                HttpDownloader().httpGetOld("https://www.profixio.com/resultater/viskamper_soek.php") {
                    (data, error) -> Void in
                    let klassCodeArray = TFHpple(htmlData: data).search(withXPathQuery: "//option[contains(.,\"\(klass)\")]")
                    
                    if(klassCodeArray?.count == 0){
                        callback(Results(HTML: "<br/>Finns inget resultat för \(klass)", hasResults: false))
                        return
                    }
                    
                    let klassCode = (klassCodeArray?[0] as! TFHppleElement).attributes["value"]! as! String
                    
                    print(klassCode)
                    print(klass)
                    HttpDownloader().httpPost("https://www.profixio.com/resultater/vis_oppsett.php",
                                              //bodyData: "kamper=on&puljeinndeling=on&klasse=alle&klubb=alle&pulje=Alle&lag=alle&vis=klasser") {
                        //bodyData: "resultatliste=on&tabeller=on&klasse=alle&klubb=alle&pulje=Alle&lag=alle&vis=klasser") {
                    bodyData: "klasse=\(klassCode)&klubb=alle&pulje=Alle&lag=alle&vis=klasser") {
                        (postResponse, String) -> Void in
                        let results = self.parseHTML(tournament, HTMLData: postResponse!)
                        callback( results )
                    }
                }
            }
        }
    }
    
    func parseHTML(_ tournament:TournamentDetail, HTMLData:Data) -> Results {
        let allCells = TFHpple(htmlData: HTMLData).search(withXPathQuery: "//table")
        let results = Results(HTML:(allCells?[0] as! TFHppleElement).raw, hasResults: true )
        return results
    }
    
    func getReserveCode(_ value:AnyObject) -> String {
        if( cleanValue(value).range(of: "Väntelista") != nil){
            return "V"
        }
        if( cleanValue(value).range(of: "önskas") != nil){
            return "Ö"
        }
        return ""
    }
    
    func cleanValue(_ value:AnyObject) -> String {
        var content = (value as! TFHppleElement).content
        
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
