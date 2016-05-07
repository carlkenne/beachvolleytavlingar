//
//  TournamentDownloader.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class TournamentDetailDownloader: DownloaderBase {
    var retries = 1
    
    func downloadHTML(tournament:Tournament, callback:(TournamentDetail) -> Void) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.selectedTournamentDetail = nil
        HttpDownloader().httpGetOld(tournament.link as String){
            (data, error) -> Void in
            if (error != nil) {
                print(error)
                callback(self.createFailedResponse(tournament))
            } else {
                if(self.areWeStillLoggedIn(data!) == true) {
                    let tournamentDetail = self.parseHTML(tournament, HTMLData: data!)
                    appDelegate.selectedTournamentDetail = tournamentDetail
                    callback(tournamentDetail)
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
            resultatLink: "",
            registrationLink: "",
            link: tournament.link,
            table: "Could not get any information, please try again later.",
            setServerSessionCookieUrl: "",
            fromHour: "",
            toHour: "",
            maxNoOfParticipants: 0
        )
    }
    
    func areWeStillLoggedIn(HTMLData:NSData) -> Bool {
        return TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//h4[contains(.,'Gjestetilgang')]").count == 0
    }
    
    func getTextFromTD(HTMLData:NSData, query:String) -> String {
        let array = TFHpple(HTMLData: HTMLData).searchWithXPathQuery(query)
        
        if(array.count > 0){
            return cleanValue(array[0])
        }
        return ""
    }
    
    func parseHTML(tournament:Tournament, HTMLData:NSData) -> TournamentDetail {
        var allCells = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//table")
        let anmalan = TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//input[@value='Anmälan']")
        let resultatLink = getTextFromTD(HTMLData, query:"//td[contains(.,'resultater/vis.php')]")
        let registrationLink = getTextFromTD(HTMLData, query:"//td[contains(.,'pamelding/redirect.php')]")
        
        let maxNoOfParticipants:String = cleanValue(TFHpple(HTMLData: HTMLData).searchWithXPathQuery("//td[@class='startkont']")[0])
        var maxNo = 100
        if(maxNoOfParticipants.characters.count > 0){
            maxNo = Int(maxNoOfParticipants)!
        }
        
        return TournamentDetail(
            resultatLink: resultatLink.stringByReplacingOccurrencesOfString("http:", withString: "https:"),
            registrationLink: registrationLink.stringByReplacingOccurrencesOfString("http:", withString: "https:"),
            link: tournament.link,
            table: (allCells[1] as! TFHppleElement).raw.stringByReplacingOccurrencesOfString("Kontaktinformation", withString: "Kontakt information"),
            setServerSessionCookieUrl: self.extractOnClickLink(anmalan),
            fromHour: "",
            toHour: "",
            maxNoOfParticipants: maxNo
        )
    }
    
    func extractOnClickLink(anmalan: [AnyObject]) -> NSString {
        if(anmalan.count == 0) {
            return ""
        }
        
        let onclickString = (anmalan[0] as! TFHppleElement).attributes["onclick"] as! NSString
        
        var str = onclickString.stringByReplacingOccurrencesOfString("window.open(\"..", withString: "")
        str = str.stringByReplacingOccurrencesOfString("\", \"_blank\")", withString: "")
        return str
    }
}