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
    
    func downloadHTML(_ tournament:Tournament, callback:@escaping (TournamentDetail) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
    
    func createFailedResponse(_ tournament: Tournament) -> TournamentDetail{
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
    
    func areWeStillLoggedIn(_ HTMLData:Data) -> Bool {
        return TFHpple(htmlData: HTMLData).search(withXPathQuery: "//h4[contains(.,'Gjestetilgang')]").count == 0
    }
    
    func getTextFromTD(_ HTMLData:Data, query:String) -> String {
        let array : [Any] = TFHpple(htmlData: HTMLData).search(withXPathQuery: query)
        
        if(array.count > 0){
            return cleanValue(array[0] as AnyObject)
        }
        return ""
    }
    
    func parseHTML(_ tournament:Tournament, HTMLData:Data) -> TournamentDetail {
        var allCells: [Any] = TFHpple(htmlData: HTMLData).search(withXPathQuery: "//table")
        let anmalan = TFHpple(htmlData: HTMLData).search(withXPathQuery: "//input[@value='Anmälan']")
        let resultatLink = getTextFromTD(HTMLData, query:"//td[contains(.,'resultater/vis.php')]")
        let registrationLink = getTextFromTD(HTMLData, query:"//td[contains(.,'pamelding/redirect.php')]")
        
        let maxNoOfParticipants:String = cleanValue(TFHpple(htmlData: HTMLData).search(withXPathQuery: "//td[@class='startkont']")[0])
        var maxNo = 100
        if(maxNoOfParticipants.characters.count > 0){
            maxNo = Int(maxNoOfParticipants)!
        }
        
        let table: TFHppleElement = (allCells[1] as! TFHppleElement)
        
        return TournamentDetail(
            resultatLink: resultatLink.replacingOccurrences(of: "http:", with: "https:"),
            registrationLink: registrationLink.replacingOccurrences(of: "http:", with: "https:"),
            link: tournament.link,
            table: table.raw.replacingOccurrences(of: "Kontaktinformation", with: "Kontakt information") as NSString,
            setServerSessionCookieUrl: self.extractOnClickLink(anmalan as! [AnyObject]),
            fromHour: "",
            toHour: "",
            maxNoOfParticipants: maxNo
        )
    }
    
    func extractOnClickLink(_ anmalan: [AnyObject]) -> NSString {
        if(anmalan.count == 0) {
            return ""
        }
        
        let onclickString = (anmalan[0] as! TFHppleElement).attributes["onclick"] as! NSString
        
        var str = onclickString.replacingOccurrences(of: "window.open(\"..", with: "")
        str = str.replacingOccurrences(of: "\", \"_blank\")", with: "")
        return str as NSString
    }
}
