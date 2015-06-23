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

            loading.startAnimating()
            TournamentDownloader().downloadHTML(tournament!){
                (res) -> Void in
                let link:String = tournament!.link
                
                var html = "<html><head><meta name=\"viewport\" content=\"width=450\"/></head><body><style>body>table {max-width:430px; }.uh{font-weight: bold;padding-right:6px;  vertical-align: top;}body>table>tbody>tr>td{padding-bottom:7px;}.startkont {text-align: right;}td{padding-right:15px;}</style>\(res.table)<br/><br/>sidlänk:  <a href=\"\(link)\">\(link)</a></body></html>"
                
                self.text.loadHTMLString(html, baseURL: NSURL(string:"http://www.profixio.com"))
                
                self.loading.stopAnimating()
            }
    }
}