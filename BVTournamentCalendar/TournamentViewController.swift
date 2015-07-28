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
    
    
    func share(sender:AnyObject) {
   /*     let tournament = (UIApplication.sharedApplication().delegate as! AppDelegate).selectedTournament
        var sec = tournament?.from.timeIntervalSinceDate(Date.parse("2001.01.01"))
        UIApplication.sharedApplication().openURL(NSURL(string:("calshow:\(sec!)"))!)
        println("calshow:\(sec!)")
        
        */
        
       /* let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationA)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
            
            
        }
        
        var eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            (granted, error) in
            
            if (granted) && (error == nil) {
                println("granted \(granted)")
                println("error \(error)")
                
                let tournament = (UIApplication.sharedApplication().delegate as! AppDelegate).selectedTournament
                
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = tournament?.name
                event.startDate = tournament?.from
                event.endDate = tournament?.to
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil) 
                
                println("Saved Event") 
            } 
        })*/
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
            
            
            var html = "<html><head><meta name=\"viewport\" content=\"width=450\"/></head><body><style>body>table>tbody>tr:first-child{display:none;}body>table>tbody>tr:nth-child(6){\(hideKlassDiv)}.uh{font-weight: bold;padding-right:6px;  vertical-align: top;}body>table>tbody>tr>td{padding-bottom:7px;}.startkont {text-align: right;}td{padding-right:15px;   max-width: 350px;overflow: hidden; text-overflow: ellipsis;}</style>\(table)<br/><br/><b>Sidlänk</a>  <a href=\"\(link)\" style=\"font-size:14px; padding-left:20px\">\(link)</a></body></html>"
            
            self.text.loadHTMLString(html, baseURL: NSURL(string:"http://www.profixio.com"))
            self.loading.stopAnimating()
        }
    }
}