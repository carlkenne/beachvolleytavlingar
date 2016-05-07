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
            let link:String = tournament!.link
            var hideKlassDiv = ""
            if(tournament?.levelCategory == "open grön" || tournament?.levelCategory == "open svart" || tournament?.levelCategory == "mixed" || tournament?.levelCategory == "challenger"){
                hideKlassDiv = "display:none"
            }
            
            var table = res.table.stringByReplacingOccurrencesOfString("<tr><td class=\"uh\">Segerpremie</td><td/></tr>", withString: "")
            table = table.stringByReplacingOccurrencesOfString("<tr><td style=\"padding-bottom:4px;\" class=\"uh\">Telefon</td><td/><td/></tr>", withString: "")
            
            
            var html = "<html><head><meta name=\"viewport\" content=\"width=450\"/></head><body><style> body>table>tbody>tr:first-child{display:none;} body>table>tbody>tr:nth-child(6){\(hideKlassDiv)} .uh{font-weight: bold;padding-right:6px;  vertical-align: top;} body>table>tbody>tr>td{padding-bottom:7px;} .startkont {text-align: right;} td{padding-right:15px;max-width:450px;overflow: hidden; text-overflow: ellipsis;} .section{background-color:#F8F8F8; padding-top:15px; padding-bottom:15px; padding-left:15px; } .section td{font-size:18pt} *{font-size:13pt !important;; font-family:helvetica}</style>\(table)<br/><br/></body></html>"
            
            html = html
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
                .removeAll("<tr><td class=\"uh\">Övrig info</td><td/></tr>&#13;")
                .removeAll("&#13;")
                .stringByReplacingOccurrencesOfString("<td>&#13;",withString:"<td class=\"section\" colspan=2>")
                .stringByReplacingOccurrencesOfString("<td class=\"uh\">Tävlingsledare</td><td class=\"uh\">Tävlingsledare</td>",withString:"<td colspan=2 class=\"uh\">Tävlingsledare</td>")
                .stringByReplacingOccurrencesOfString("<tr><td class=\"uh\">Klasser</td><td>",withString:"<tr class=\"section\"><td class=\"uh section\">Klasser</td><td class=\"section\">")
                .stringByReplacingOccurrencesOfString("</table><br/><br/>",withString:"<tr><td class=\"uh\">Sidlänk</td><td>\(link)</td></tr></table><br/><br/>")
 
            print (html)
            self.text.loadHTMLString(html, baseURL: NSURL(string:"https://www.profixio.com"))
            self.loading.stopAnimating()
        }
    }
}
