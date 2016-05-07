
import UIKit
import Foundation
import EventKit

class ResultsViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var text : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        showResults()
    }
    
    @IBAction func classChanged(sender: AnyObject) {
        showResults()
    }
    
    @IBOutlet weak var classPicker: UISegmentedControl!
    
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
    
    func showResults(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let tournament = appDelegate.selectedTournament
        self.text.loadHTMLString("", baseURL:NSURL(string:"https://www.profixio.com"))
        parentViewController?.title = tournament?.name
        
        loading.startAnimating()
        var klasse = "Damer"
        if(classPicker.selectedSegmentIndex == 1){
            klasse = "Herrar"
        }
        ResultsDownloader().downloadHTML(appDelegate.selectedTournamentDetail, klass:klasse){
            (res) -> Void in
            
            let link:String = appDelegate.selectedTournamentDetail!.resultatLink
            let table = res.HTML
                .stringByReplacingOccurrencesOfString("&nbsp;", withString:" ")
                .stringByReplacingOccurrencesOfString("<td/>", withString:"")
                .stringByReplacingOccurrencesOfString("<td> - </td>", withString:"")
                .stringByReplacingOccurrencesOfString(">=\"3\"", withString:">=\"3\"")
                .stringByReplacingOccurrencesOfString(" - ", withString:"&nbsp;-&nbsp;")
                .stringByReplacingOccurrencesOfString(", ", withString:",&nbsp;")
                .stringByReplacingOccurrencesOfString("colspan=\"3\"", withString:"")
                .stringByReplacingOccurrencesOfString("    ", withString:"")
                .stringByReplacingOccurrencesOfString("text-decoration:none", withString:"white-space:nowrap; width:0%; display:none;")
                .stringByReplacingOccurrencesOfString("<tr><td colspan=\"9\"><span class=\"os_klasse\">Klass D&nbsp;-&nbsp;Damer </span> <br/></td></tr>", withString:"")
                 .stringByReplacingOccurrencesOfString("<tr><td colspan=\"9\"><span class=\"os_klasse\">Klass H&nbsp;-&nbsp;Herrar </span> <br/></td></tr>", withString:"")
                .stringByReplacingOccurrencesOfString("&#13;", withString:"")
                .stringByReplacingOccurrencesOfString("colspan=\"9\"", withString:"colspan=\"4\"")
                .stringByReplacingOccurrencesOfString("<tr><td colspan=\"4\"> </td></tr>", withString:"")
                .stringByReplacingOccurrencesOfString("<td> Final  </td>", withString:"<td>Final&nbsp;</td>")
                .stringByReplacingOccurrencesOfString("<td> Semifinal 2  </td>", withString:"<td>SF&nbsp;2&nbsp;&nbsp;</td>")
                .stringByReplacingOccurrencesOfString("<td> Semifinal 1  </td>", withString:"<td>SF&nbsp;1&nbsp;&nbsp;</td>")
                .stringByReplacingOccurrencesOfString("<td> Kvartsfinal 1  </td>", withString:"<td>KF&nbsp;1&nbsp;&nbsp;</td>")
                .stringByReplacingOccurrencesOfString("<td> Kvartsfinal 2  </td>", withString:"<td>KF&nbsp;2&nbsp;&nbsp;</td>")
                .stringByReplacingOccurrencesOfString("<td> Kvartsfinal 3  </td>", withString:"<td>KF&nbsp;3&nbsp;&nbsp;</td>")
                .stringByReplacingOccurrencesOfString("<td> Kvartsfinal 4  </td>", withString:"<td>KF&nbsp;4&nbsp;&nbsp;</td>")
                .stringByReplacingOccurrencesOfString("<!--tr><td colspan='9'>", withString:"")
                .stringByReplacingOccurrencesOfString("<table cellspacing='0' border='0' -->", withString:"</table><table>")
                .stringByReplacingOccurrencesOfString("<tr><td colspan=\"4\"><span class=\"os_pulje\">", withString:"</table><table><tr><td colspan=\"4\"><span class=\"os_pulje\">")
                .stringByReplacingOccurrencesOfString("colspan=\"4\"", withString:"colspan=\"4\" style=\"padding-bottom:5px\"")
                .stringByReplacingOccurrencesOfString("<table>", withString:"<table cellspacing=\"1\" style=\"margin-bottom:20px; \">")
                .stringByReplacingOccurrencesOfString("D&nbsp;-&nbsp;", withString:"")
                .stringByReplacingOccurrencesOfString("H&nbsp;-&nbsp;", withString:"")
                .stringByReplacingOccurrencesOfString("#DDDDDD", withString:"#F7F0DF")
                .stringByReplacingOccurrencesOfString("#EEEEEE", withString:"#FFFBF0")
                .stringByReplacingOccurrencesOfString("<td>Bana", withString:"<td style=\"display:none\">Bana")
                .stringByReplacingOccurrencesOfString("<td> </td>", withString:"")
            print(table)
            
            var aLink = "<a href=\"\(link)\" style=\"!important; padding-bottom:10px; font-family:helvetica; font-size: 20px; text-decoration: none;\">Till resultatsidan &gt;</a>"
            if(link == ""){
                aLink = ""
            }
            
            let html = "<html><head><meta name=\"viewport\" content=\"width=450\"/><style>.kampnr{display:none;} table td{font-size:16px; padding:3px; font-family:helvetica} </style></head><body>\(table)<br/>\(aLink)</body></html>"
            
            self.text.loadHTMLString(html, baseURL: NSURL(string:"https://www.profixio.com"))
            self.loading.stopAnimating()
        }
    }
}