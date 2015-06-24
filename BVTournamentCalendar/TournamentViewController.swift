//
//  TournamentViewController.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 28/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit
import Foundation

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
        appDelegate.selectedTournamentDetail = nil

        
            loading.startAnimating()
            TournamentDetailDownloader().downloadHTML(tournament!){
                (res) -> Void in
                let link:String = tournament!.link
                
                var html = "<html><head><meta name=\"viewport\" content=\"width=450\"/></head><body><style>body>table>tbody>tr:first-child{display:none;}.uh{font-weight: bold;padding-right:6px;  vertical-align: top;}body>table>tbody>tr>td{padding-bottom:7px;}.startkont {text-align: right;}td{padding-right:15px;   max-width: 350px;overflow: hidden; text-overflow: ellipsis;}</style>\(res.table)<br/><br/><b>Sidlänk</a>  <a href=\"\(link)\" style=\"font-size:14px; padding-left:20px\">\(link)</a></body></html>"
                
                self.text.loadHTMLString(html, baseURL: NSURL(string:"http://www.profixio.com"))
                
                self.loading.stopAnimating()
                
                appDelegate.selectedTournamentDetail = res
            }
    }
}