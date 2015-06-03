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
    var tournament:Tournament?
    var loaded = false
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var text : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = true
        text.delegate = self
        if(tournament != nil){
            showTournament()
        }
    }

    func webView(webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            
            if (navigationType == UIWebViewNavigationType.LinkClicked){
                UIApplication.sharedApplication().openURL(request.URL)
                return false
            }
            return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTournament(){
        if(loaded == true) {
            loading.startAnimating()
            TournamentDownloader().downloadHTML(self.tournament!){
                (res) -> Void in
                let link:NSString? = self.tournament?.link
                
                var html = "<html><head><meta name=\"viewport\" content=\"width=450\"/></head><body><style>body>table {max-width:430px; }</style>" + res.table + "<br/><br/>sidlänk:  <a href=\"" + link! + " \">" + link! + "</a></body></html>"
                
                self.text.loadHTMLString(html, baseURL: NSURL(string:"http://www.profixio.com"))
                
                self.loading.stopAnimating()
            }
        }
    }
}