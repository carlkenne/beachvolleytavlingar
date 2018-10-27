//
//  TournamentViewController.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 28/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit
import Foundation
import EventKit

class TournamentViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var text : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        showTournament()
    }
 
    func webView(_ webView: UIWebView,
        shouldStartLoadWith request: URLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            
        if (navigationType == UIWebViewNavigationType.linkClicked){
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    func onWeatherReceived(weatherString: String) {
            self.weatherLabel.text = weatherString
    }

    func showTournament(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tournament = appDelegate.selectedTournament
        
        
        
        parent?.title = tournament?.name
        
        loading.startAnimating()
        TournamentDetailDownloader().downloadHTML(tournament!){
            (res) -> Void in
            
            let link:String = res.link
            let registrationLink:String = res.registrationLink
            let liveResultatLink:String = res.liveResultatLink
            
            var hideKlassDiv = ""
            if(tournament?.levelCategory == "open grön" || tournament?.levelCategory == "open svart" || tournament?.levelCategory == "mixed" || tournament?.levelCategory == "challenger"){
                hideKlassDiv = "display:none"
            }
            
            let weatherHelper = WeatherHelper()
            weatherHelper.getWeather(tournament: tournament!, details: res, onCompletion: self.onWeatherReceived)
            
            var table = res.table.replacingOccurrences(of: "<tr><td class=\"uh\">Segerpremie</td><td/></tr>", with: "")
            table = table.replacingOccurrences(of: "<tr><td style=\"padding-bottom:4px;\" class=\"uh\">Telefon</td><td/><td/></tr>", with: "")
            
            var html = "<html>" +
                "<head> <meta name=\"viewport\" content=\"width=450\"/> </head>" +
                "<body><style> " +
                    "body>table>tbody>tr:first-child { display: none; } " +
                    "body>table>tbody>tr:nth-child(6) { \(hideKlassDiv) } " +
                    ".uh { font-weight: bold; padding-right: 6px; } " +
                    "body>table>tbody>tr>td { padding-bottom: 7px; } " +
                    ".startkont { text-align: right; } " +
                    "td { padding-right: 15px; max-width: 450px; overflow: hidden; text-overflow: ellipsis; } " +
                    ".section { background-color: #F8F8F8; padding-top: 15px; padding-bottom: 15px; padding-left: 15px; } " +
                    "* { font-size: 13pt !important; font-family: helvetica; } " +
                    ".app-link { padding-bottom:10px; display:inline-block; text-decoration: none; font-size:22px !important; }" +
                "</style> " +
                "\(table)" +
                "<br/>" +
                "<a href=\"\(liveResultatLink)\" class\"app-link\">Till liverapportering av resultat &gt;</a>" +
                "<br/><br/>" +
                "<a href=\"\(registrationLink)\" class\"app-link\">Till anmälan &gt;</a>" +
                "<br/><br/>" +
                "<a href=\"\(link)\" class\"app-link\">Till sidan &gt;</a>" +
                "</body></html>";
       //     print(html)
            html = html
                .replacingOccurrences(of: "+ D (född -",with:"+&nbsp;D&nbsp;(född&nbsp;-")
                .replacingOccurrences(of: "<td class=\"uh\">Kategori</td>",with:"")
                .replacingOccurrences(of: "Sista anmälningsdag</td><td>",with:"ANMÄL DIG SENAST</td></tr><tr><td style=\"padding-left:20px;\">")
                .replacingOccurrences(of: "<tr><td class=\"uh\">Klasser och kategorier</td>",with:"<tr style=\"display: none;\"><td class=\"uh\">Klasser och kategorier</td>")
                .replacingOccurrences(of: "<td class=\"uh\">Arrangör</td><td>",with:"<td colspan=2 style=\"font-weight:bold\">")
                .replacingOccurrences(of: "<td class=\"uh\">Nivå</td><td>",with:"<td colspan=2>")
                .removeAll("<td class=\"uh\">Datum</td>")
                .replacingOccurrences(of: "<td>&#13;",with:"<td class=\"section\" colspan=2>")
                .removeAll("<td class=\"uh\">Kontakt information</td>")
                .replacingOccurrences(of: "Inbetalningsinfo",with:"Betalning")
                .replacingOccurrences(of: "Klassdetaljer",with:"Klasser")
                .removeAll("<tr><td style=\"padding-bottom:4px;\" class=\"uh\">Namn</td><td/><td/></tr>&#13;")
                .replacingOccurrences(of: "<td style=\"padding-bottom:4px;\" class=\"uh\">Namn</td>", with:"<td/>")
                .replacingOccurrences(of: "<td style=\"padding-bottom:4px;\" class=\"uh\">Telefon</td>",with:"<td/>")
                .replacingOccurrences(of: "<td style=\"padding-bottom:4px;\" class=\"uh\">Epost</td>",with:"<td/>")
                .removeAll("<tr><td class=\"uh\">Övrig info</td><td/></tr>&#13;")
                .removeAll("&#13;")
                .removeAll("<td style=\"padding-bottom:4px;\"/>")
                .replacingOccurrences(of: "<td>&#13;",with:"<td class=\"section\" colspan=2>")
                .replacingOccurrences(of: "<td class=\"uh\">Tävlingsledare</td><td class=\"uh\">Tävlingsledare</td>",with:"<td colspan=3 class=\"uh\" style=\"padding-bottom:4px;font-size:16px !important\">TÄVLINGSLEDARE</td>")
                .replacingOccurrences(of: "<tr><td class=\"uh\">Klasser</td><td>",with:"<tr class=\"section\"><td class=\"uh section\">Klasser</td><td class=\"section\">")
                .replacingOccurrences(of: "<tr><td class=\"uh\">Anmälan",with:"<tr style=\"display:none\"><td class=\"uh\">Anmälan")
                .replacingOccurrences(of: "<tr><td class=\"uh\">Spelschema",with:"<tr style=\"display:none\"><td class=\"uh\">Spelschema")
                .replacingOccurrences(of: "<td class=\"uh\">Övrig info</td><td",with:"<td class=\"uh\" colspan=\"2\" style=\"padding-bottom:4px;padding-top:20px;font-size:8pt !important;\">ÖVRIG INFO</td></tr><tr><td colspan=\"2\" style=\"padding-left:20px\"")
                .replacingOccurrences(of: "<td class=\"uh\">Betalning</td><td",with:"<td class=\"uh\" colspan=\"2\" style=\"padding-bottom:4px;padding-top:20px;font-size:8pt !important;\">BETALNING</td></tr><tr><td colspan=\"2\" style=\"padding-left:20px\"")
                .replacingOccurrences(of: "<td class=\"uh section\">Klasser</td>",with:"")
                .replacingOccurrences(of: "<td class=\"uh\">D</td>",with:"<td class=\"uh\">Damer</td>")
                .replacingOccurrences(of: "<td class=\"uh\">H</td>",with:"<td class=\"uh\">Herrar</td>")
                .replacingOccurrences(of: "<td style=\"padding-bottom:4px;\" class=\"uh\">Från:",with:"<td class=\"uh\">FRÅN")
                .replacingOccurrences(of: "Till:",with:"TILL")
                .replacingOccurrences(of: "ca kl:",with:"CA KL")
                .replacingOccurrences(of: "<td style=\"padding-bottom:4px;\" class=\"uh\">kl:",with:"<td class=\"uh\">KL")
                .replacingOccurrences(of: ">Antal",with:">ANTAL")
                .replacingOccurrences(of: ">Startavgift",with:">STARTAVGIFT")
                .replacingOccurrences(of: "00.00",with:"00 kr")
                .replacingOccurrences(of: "50.00",with:"50 kr")
            //print("-----------------")
            //print(html)

            self.text.loadHTMLString(html, baseURL: URL(string:"https://www.profixio.com"))
            self.loading.stopAnimating()
        }
    }
}
