
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
    
    @IBAction func classChanged(_ sender: AnyObject) {
        showResults()
    }
    
    @IBOutlet weak var classPicker: UISegmentedControl!
    
    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                                            navigationType: UIWebViewNavigationType) -> Bool {
        
        if (navigationType == UIWebViewNavigationType.linkClicked){
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showResults(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tournament = appDelegate.selectedTournament
        self.text.loadHTMLString("", baseURL:URL(string:"https://www.profixio.com"))
        parent?.title = tournament?.name
        
        loading.startAnimating()
        classPicker.isHidden = false
        var klasse = "Damer"
        if(classPicker.selectedSegmentIndex == 1){
            klasse = "Herrar"
        }
        
        if(tournament?.levelCategory == "mixed") {
            klasse = "Mixed"
            classPicker.isHidden = true
        }
        
        ResultsDownloader().downloadHTML(appDelegate.selectedTournamentDetail, klass:klasse){
            (res) -> Void in
            print("zzzzzzzzzzzzz")
            print(res.HTML)
            print("zzzzzzzzzzzzz")
            let link:String = appDelegate.selectedTournamentDetail!.resultatLinkNew
            let liveLink:String = appDelegate.selectedTournamentDetail!.liveResultatLink
            var table = res.HTML
                .replacingOccurrences(of: " / ", with:"<br/>")
                .replacingOccurrences(of: "        </td>", with:" </td>")
                .replacingOccurrences(of: "<td/>", with:"")
                .replacingOccurrences(of: "<td> - </td>", with:"")
                .replacingOccurrences(of: ">=\"3\"", with:">=\"3\"")
                .replacingOccurrences(of: "td>1", with:"td style=\"display:none\">")
                .replacingOccurrences(of: "td>2", with:"td style=\"display:none\">")
                .replacingOccurrences(of: "td>0", with:"td style=\"display:none\">")
                .replacingOccurrences(of: " - ", with:"&nbsp;-&nbsp;")
                .replacingOccurrences(of: "(", with:"")
                .replacingOccurrences(of: ")", with:"")
                .replacingOccurrences(of: "1, ", with:"1<br/>")
                .replacingOccurrences(of: "2, ", with:"2<br/>")
                .replacingOccurrences(of: "3, ", with:"3<br/>")
                .replacingOccurrences(of: "4, ", with:"4<br/>")
                .replacingOccurrences(of: "5, ", with:"5<br/>")
                .replacingOccurrences(of: "6, ", with:"6<br/>")
                .replacingOccurrences(of: "7, ", with:"7<br/>")
                .replacingOccurrences(of: "8, ", with:"8<br/>")
                .replacingOccurrences(of: "9, ", with:"9<br/>")
                .replacingOccurrences(of: "0, ", with:"0<br/>")
                .replacingOccurrences(of: "1-", with:"1&#8209;")
                .replacingOccurrences(of: "2-", with:"2&#8209;")
                .replacingOccurrences(of: "3-", with:"3&#8209;")
                .replacingOccurrences(of: "4-", with:"4&#8209;")
                .replacingOccurrences(of: "5-", with:"5&#8209;")
                .replacingOccurrences(of: "6-", with:"6&#8209;")
                .replacingOccurrences(of: "7-", with:"7&#8209;")
                .replacingOccurrences(of: "8-", with:"8&#8209;")
                .replacingOccurrences(of: "9-", with:"9&#8209;")
                .replacingOccurrences(of: "0-", with:"0&#8209;")
                .replacingOccurrences(of: "e-", with:"e&#8209;")
                .replacingOccurrences(of: ", ", with:",&nbsp;")
                .replacingOccurrences(of: "colspan=\"3\"", with:"")
                .replacingOccurrences(of: "<tr><td colspan=\"9\"><span class=\"os_klasse\">Klass D&nbsp;-&nbsp;Damer </span> <br/></td></tr>", with:"")
                 .replacingOccurrences(of: "<tr><td colspan=\"9\"><span class=\"os_klasse\">Klass H&nbsp;-&nbsp;Herrar </span> <br/></td></tr>", with:"")
                .replacingOccurrences(of: "<tr><td colspan=\"9\"><span class=\"os_klasse\">Klass M&nbsp;-&nbsp;Mixed </span> <br/></td></tr>", with:"")
                .replacingOccurrences(of: "&#13;", with:"")
                .replacingOccurrences(of: "colspan=\"9\"", with:"colspan=\"4\"")
                .replacingOccurrences(of: "<tr><td colspan=\"4\"> </td></tr>", with:"")
                .replacingOccurrences(of: "<td> Final  </td>", with:"<td>Final&nbsp;</td>")
                .replacingOccurrences(of: "<td> Semifinal 2  </td>", with:"<td>SF&nbsp;2&nbsp;&nbsp;</td>")
                .replacingOccurrences(of: "<td> Semifinal 1  </td>", with:"<td>SF&nbsp;1&nbsp;&nbsp;</td>")
                .replacingOccurrences(of: "<td> Kvartsfinal 1  </td>", with:"<td>KF&nbsp;1&nbsp;&nbsp;</td>")
                .replacingOccurrences(of: "<td> Kvartsfinal 2  </td>", with:"<td>KF&nbsp;2&nbsp;&nbsp;</td>")
                .replacingOccurrences(of: "<td> Kvartsfinal 3  </td>", with:"<td>KF&nbsp;3&nbsp;&nbsp;</td>")
                .replacingOccurrences(of: "<td> Kvartsfinal 4  </td>", with:"<td>KF&nbsp;4&nbsp;&nbsp;</td>")
                .replacingOccurrences(of: "<!--tr><td colspan='9'>", with:"")
                .replacingOccurrences(of: "<table cellspacing='0' border='0' -->", with:"</table><table>")
                .replacingOccurrences(of: "<tr><td colspan=\"4\"><span class=\"os_pulje\">", with:"</table><table><tr><td colspan=\"4\"><span class=\"os_pulje\">")
                .replacingOccurrences(of: "colspan=\"4\"", with:"colspan=\"4\" style=\"padding-bottom:5px\"")
                .replacingOccurrences(of: "<table>", with:"<table cellspacing=\"1\" style=\"margin-bottom:20px; \">")
                .replacingOccurrences(of: "D&nbsp;-&nbsp;", with:"")
                .replacingOccurrences(of: "H&nbsp;-&nbsp;", with:"")
                .replacingOccurrences(of: "#DDDDDD", with:"#F7F0DF")
                .replacingOccurrences(of: "#EEEEEE", with:"#FFFBF0")
                .replacingOccurrences(of: "<td>Bana", with:"<td style=\"display:none\">Bana")
                .replacingOccurrences(of: "<td> </td>", with:"")
                .replacingOccurrences(of: "Åttondel", with:"8-del")
                .replacingOccurrences(of: "Sextondel", with:"16-del")
            //print(table)
            
            var aLink = "<a href=\"\(liveLink)\" style=\"!important; padding-bottom:10px; font-family:helvetica; font-size: 18px; text-decoration: none;\">Liverapportering av resultat (Safari) &gt;</a>" +
                "<br/><br/>" +
                "<a href=\"\(link)\" style=\"!important; padding-bottom:10px; font-family:helvetica; font-size: 18px; text-decoration: none;\">Se resultat (Safari) &gt;</a>"
            
            if(appDelegate.selectedTournament!.name.contains("Swedish Beach Tour")) {
                aLink = "<a href=\"http://www.swedishbeachtour.se/resultat-2018\" style=\"!important; padding-bottom:10px; font-family:helvetica; font-size: 18px; text-decoration: none;\">Till Swedishbeachtour.se (Safari) &gt;</a>"
            }
            
            if(!res.hasResults && link == ""){
                table = "<br/>Resultat ej tillgängligt "
                aLink = ""
            }
            
            let html = "<html><head><meta name=\"viewport\" content=\"width=450\"/>" +
                "<style>.kampnr{display:none;}" +
                "table td {font-size:16px; padding:5px; font-family:helvetica;vertical-align:middle;}" +
                "table {width:100%;}" +
                "</style></head><body>\(table)<br/>\(aLink)</body></html>"
            
            self.text.loadHTMLString(html, baseURL: URL(string:"https://www.profixio.com"))
            self.loading.stopAnimating()
            print(html)
        }
    }
}
