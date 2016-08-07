
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
        classPicker.hidden = false
        var klasse = "Damer"
        if(classPicker.selectedSegmentIndex == 1){
            klasse = "Herrar"
        }
        
        if(tournament?.levelCategory == "mixed") {
            klasse = "Mixed"
            classPicker.hidden = true
        }
        
        ResultsDownloader().downloadHTML(appDelegate.selectedTournamentDetail, klass:klasse){
            (res) -> Void in
            print("zzzzzzzzzzzzz")
            print(res.HTML)
            print("zzzzzzzzzzzzz")
            let link:String = appDelegate.selectedTournamentDetail!.resultatLink
            let table = res.HTML
                .stringByReplacingOccurrencesOfString(" / ", withString:"<br/>")
                //.stringByReplacingOccurrencesOfString("&nbsp;&nbsp;", withString:"")
                //.stringByReplacingOccurrencesOfString("&nbsp; &nbsp;", withString:"")
                .stringByReplacingOccurrencesOfString("        </td>", withString:" </td>")
                .stringByReplacingOccurrencesOfString("<td/>", withString:"")
                .stringByReplacingOccurrencesOfString("<td> - </td>", withString:"")
                .stringByReplacingOccurrencesOfString(">=\"3\"", withString:">=\"3\"")
                .stringByReplacingOccurrencesOfString("td>1", withString:"td style=\"display:none\">")
                .stringByReplacingOccurrencesOfString("td>2", withString:"td style=\"display:none\">")
                .stringByReplacingOccurrencesOfString("td>0", withString:"td style=\"display:none\">")
                .stringByReplacingOccurrencesOfString(" - ", withString:"&nbsp;-&nbsp;")
                .stringByReplacingOccurrencesOfString("(", withString:"")
                .stringByReplacingOccurrencesOfString(")", withString:"")
                .stringByReplacingOccurrencesOfString("1, ", withString:"1<br/>")
                .stringByReplacingOccurrencesOfString("2, ", withString:"2<br/>")
                .stringByReplacingOccurrencesOfString("3, ", withString:"3<br/>")
                .stringByReplacingOccurrencesOfString("4, ", withString:"4<br/>")
                .stringByReplacingOccurrencesOfString("5, ", withString:"5<br/>")
                .stringByReplacingOccurrencesOfString("6, ", withString:"6<br/>")
                .stringByReplacingOccurrencesOfString("7, ", withString:"7<br/>")
                .stringByReplacingOccurrencesOfString("8, ", withString:"8<br/>")
                .stringByReplacingOccurrencesOfString("9, ", withString:"9<br/>")
                .stringByReplacingOccurrencesOfString("0, ", withString:"0<br/>")
                .stringByReplacingOccurrencesOfString("1-", withString:"1&#8209;")
                .stringByReplacingOccurrencesOfString("2-", withString:"2&#8209;")
                .stringByReplacingOccurrencesOfString("3-", withString:"3&#8209;")
                .stringByReplacingOccurrencesOfString("4-", withString:"4&#8209;")
                .stringByReplacingOccurrencesOfString("5-", withString:"5&#8209;")
                .stringByReplacingOccurrencesOfString("6-", withString:"6&#8209;")
                .stringByReplacingOccurrencesOfString("7-", withString:"7&#8209;")
                .stringByReplacingOccurrencesOfString("8-", withString:"8&#8209;")
                .stringByReplacingOccurrencesOfString("9-", withString:"9&#8209;")
                .stringByReplacingOccurrencesOfString("0-", withString:"0&#8209;")
                .stringByReplacingOccurrencesOfString("e-", withString:"e&#8209;")
                .stringByReplacingOccurrencesOfString(", ", withString:",&nbsp;")
                .stringByReplacingOccurrencesOfString("colspan=\"3\"", withString:"")
               // .stringByReplacingOccurrencesOfString("text-decoration:none", withString:"white-space:nowrap; width:0%; display:none;")
                .stringByReplacingOccurrencesOfString("<tr><td colspan=\"9\"><span class=\"os_klasse\">Klass D&nbsp;-&nbsp;Damer </span> <br/></td></tr>", withString:"")
                 .stringByReplacingOccurrencesOfString("<tr><td colspan=\"9\"><span class=\"os_klasse\">Klass H&nbsp;-&nbsp;Herrar </span> <br/></td></tr>", withString:"")
                .stringByReplacingOccurrencesOfString("<tr><td colspan=\"9\"><span class=\"os_klasse\">Klass M&nbsp;-&nbsp;Mixed </span> <br/></td></tr>", withString:"")
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
                .stringByReplacingOccurrencesOfString("Åttondel", withString:"8-del")
                .stringByReplacingOccurrencesOfString("Sextondel", withString:"16-del")
            //print(table)
            
            var aLink = "<a href=\"\(link)\" style=\"!important; padding-bottom:10px; font-family:helvetica; font-size: 20px; text-decoration: none;\">Till resultatsidan (Safari) &gt;</a>"
            if(!res.hasResults){
                aLink = ""
            }
            
            let html = "<html><head><meta name=\"viewport\" content=\"width=450\"/>" +
                "<style>.kampnr{display:none;}" +
                "table td {font-size:16px; padding:5px; font-family:helvetica;vertical-align:middle;}" +
                "table {width:100%;}" +
                "</style></head><body>\(table)<br/>\(aLink)</body></html>"
            
            self.text.loadHTMLString(html, baseURL: NSURL(string:"https://www.profixio.com"))
            self.loading.stopAnimating()
            print(html)
        }
    }
}