//
//  ResultsDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 06/05/16.
//  Copyright © 2016 Carl Kenne. All rights reserved.
//

import Foundation


struct Results {
    let HTML: String
}

class ResultsDownloader {
    func downloadHTML(detail: TournamentDetail?, klass:String, callback:(Results) -> Void) {
        resultsDownload(detail!, klass:klass, callback: callback);
    }
    
    func resultsDownload(tournament:TournamentDetail, klass:String, callback:(Results) -> Void) {
        print(tournament.resultatLink)
        HttpDownloader().httpGetOld(tournament.resultatLink) {
            (data, error) -> Void in
            if error != nil {
                print(error)
                callback(Results(HTML: "RESULTAT KUNDE EJ HÄMTAS"))
            } else {
                HttpDownloader().httpGetOld("https://www.profixio.com/resultater/viskamper_soek.php") {
                    (data, error) -> Void in
                    let klassCode = (TFHpple(HTMLData: data).searchWithXPathQuery("//option[contains(.,\"\(klass)\")]")[0] as! TFHppleElement).attributes["value"]! as! String
                    
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
    
    
    func parseHTML(tournament:TournamentDetail, HTMLData:NSData) -> Results {
        let allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table")
        let results = Results(HTML:(allCells[0] as! TFHppleElement).raw )
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