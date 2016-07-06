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
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var text : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        showTournament()
    }
 
    func webView(webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            
        if (navigationType == UIWebViewNavigationType.LinkClicked){
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTournament(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let tournament = appDelegate.selectedTournament
        
        parentViewController?.title = tournament?.name
        
        loading.startAnimating()
        TournamentDetailDownloader().downloadHTML(tournament!){
            (res) -> Void in
            
            let link:String = res.link
            let registrationLink:String = res.registrationLink
            var hideKlassDiv = ""
            if(tournament?.levelCategory == "open grön" || tournament?.levelCategory == "open svart" || tournament?.levelCategory == "mixed" || tournament?.levelCategory == "challenger"){
                hideKlassDiv = "display:none"
            }
            
            var table = res.table.stringByReplacingOccurrencesOfString("<tr><td class=\"uh\">Segerpremie</td><td/></tr>", withString: "")
            table = table.stringByReplacingOccurrencesOfString("<tr><td style=\"padding-bottom:4px;\" class=\"uh\">Telefon</td><td/><td/></tr>", withString: "")
            
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
                "<a href=\"\(registrationLink)\" class\"app-link\">Till anmälan &gt;</a>" +
                "<br/><br/>" +
                "<a href=\"\(link)\" class\"app-link\">Till sidan &gt;</a>" +
                "</body></html>";
            
            print(html)
            print("-----------------------------------------------------------")
            
            html = html
                .stringByReplacingOccurrencesOfString("+ D (född -",withString:"+&nbsp;D&nbsp;(född&nbsp;-")
                .stringByReplacingOccurrencesOfString("<tr><td class=\"uh\">Klasser och kategorier</td>",withString:"<tr style=\"display: none;\"><td class=\"uh\">Klasser och kategorier</td>")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">Arrangör</td><td>",withString:"<td colspan=2 style=\"font-weight:bold\">")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">Spelplats/hall</td><td>",withString:"<td colspan=2>")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">Nivå</td><td>",withString:"<td colspan=2>")
                .removeAll("<td class=\"uh\">Datum</td>")
                .stringByReplacingOccurrencesOfString("<td>&#13;",withString:"<td class=\"section\" colspan=2>")
                .removeAll("<td class=\"uh\">Kontakt information</td>")
                .stringByReplacingOccurrencesOfString("Inbetalningsinfo",withString:"Betalning")
                .stringByReplacingOccurrencesOfString("Klassdetaljer",withString:"Klasser")
                .stringByReplacingOccurrencesOfString("Sista anmäliningsdag",withString:"Anmäl dig senast")
                .removeAll("<tr><td style=\"padding-bottom:4px;\" class=\"uh\">Namn</td><td/><td/></tr>&#13;")
                .stringByReplacingOccurrencesOfString("<td style=\"padding-bottom:4px;\" class=\"uh\">Namn</td>", withString:"<td/>")
                .stringByReplacingOccurrencesOfString("<td style=\"padding-bottom:4px;\" class=\"uh\">Telefon</td>",withString:"<td/>")
                .stringByReplacingOccurrencesOfString("<td style=\"padding-bottom:4px;\" class=\"uh\">Epost</td>",withString:"<td/>")
                .removeAll("<tr><td class=\"uh\">Övrig info</td><td/></tr>&#13;")
                .removeAll("&#13;")
                .removeAll("<td style=\"padding-bottom:4px;\"/>")
                .stringByReplacingOccurrencesOfString("<td>&#13;",withString:"<td class=\"section\" colspan=2>")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">Tävlingsledare</td><td class=\"uh\">Tävlingsledare</td>",withString:"<td colspan=3 class=\"uh\" style=\"padding-bottom:4px;font-size:16px !important\">TÄVLINGSLEDARE</td>")
                .stringByReplacingOccurrencesOfString("<tr><td class=\"uh\">Klasser</td><td>",withString:"<tr class=\"section\"><td class=\"uh section\">Klasser</td><td class=\"section\">")
                .stringByReplacingOccurrencesOfString("<tr><td class=\"uh\">Anmälan",withString:"<tr style=\"display:none\"><td class=\"uh\">Anmälan")
                .stringByReplacingOccurrencesOfString("<tr><td class=\"uh\">Spelschema",withString:"<tr style=\"display:none\"><td class=\"uh\">Spelschema")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">Anmäl dig senast</td><td",withString:"<td class=\"uh\" colspan=\"2\" style=\"padding-bottom:4px;padding-top:20px;font-size:8pt !important;\">ANMÄL DIG SENAST</td></tr><tr><td colspan=\"2\" style=\"padding-left:20px\"")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">Övrig info</td><td",withString:"<td class=\"uh\" colspan=\"2\" style=\"padding-bottom:4px;padding-top:20px;font-size:8pt !important;\">ÖVRIG INFO</td></tr><tr><td colspan=\"2\" style=\"padding-left:20px\"")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">Betalning</td><td",withString:"<td class=\"uh\" colspan=\"2\" style=\"padding-bottom:4px;padding-top:20px;font-size:8pt !important;\">BETALNING</td></tr><tr><td colspan=\"2\" style=\"padding-left:20px\"")
                .stringByReplacingOccurrencesOfString("<td class=\"uh section\">Klasser</td>",withString:"")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">D</td>",withString:"<td class=\"uh\">Damer</td>")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">H</td>",withString:"<td class=\"uh\">Herrar</td>")
                .stringByReplacingOccurrencesOfString("<td style=\"padding-bottom:4px;\" class=\"uh\">Från:",withString:"<td class=\"uh\">FRÅN")
                .stringByReplacingOccurrencesOfString("Till:",withString:"TILL")
                .stringByReplacingOccurrencesOfString("ca kl:",withString:"CA KL")
                .stringByReplacingOccurrencesOfString("<td style=\"padding-bottom:4px;\" class=\"uh\">kl:",withString:"<td class=\"uh\">KL")
                .stringByReplacingOccurrencesOfString(">Antal",withString:">ANTAL")
                .stringByReplacingOccurrencesOfString(">Startavgift",withString:">STARTAVGIFT")
                .stringByReplacingOccurrencesOfString("0.00",withString:"0 kr")
            
 
            print(html)
            
            self.text.loadHTMLString(html, baseURL: NSURL(string:"https://www.profixio.com"))
            self.loading.stopAnimating()
        }
    }
}
