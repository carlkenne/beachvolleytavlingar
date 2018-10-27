import UIKit

class TournamentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table : UITableView!
    @IBOutlet weak var loading : UIActivityIndicatorView!

    @IBOutlet weak var filterLabel: UIButton!
    @IBOutlet weak var Open: UIBarButtonItem!
    var results = [PeriodTableSection]()
    var filter = FilterSettings()
    var typesToExclude = NSSet()
    var rawDownloadedData = [Tournament]()
    var filterSaveKey = "TournamentFilter"
    
    @IBAction func saveFilterSettings(_ segue:UIStoryboardSegue) {
        if let filterSettings = segue.source as? FilterSettingsViewController {
            
            var excludes = [String]()
            if(!filterSettings.black.isOn){
                excludes.append("open svart")
            }
            if(!filterSettings.green.isOn){
                excludes.append("open grön")
            }
            if(!filterSettings.challenger.isOn){
                excludes.append("challenger")
            }
            if(!filterSettings.Mixed.isOn){
                excludes.append("mixed")
            }
            if(!filterSettings.misc.isOn){
                excludes.append("övrigt")
            }
            if(!filterSettings.swedishBeachTour.isOn){
                excludes.append("swedish beach tour")
            }
            if(!filterSettings.sm.isOn){
                excludes.append("sm")
            }
            if(!filterSettings.hideOld.isOn){
                excludes.append("hideOld")
            }

            let defaults = UserDefaults.standard
            defaults.set(excludes, forKey: filterSaveKey)
            defaults.synchronize()
            
            typesToExclude = NSSet(array: excludes)
            filterData()
        }
    }
    
    var refreshControl:UIRefreshControl!
    
    func refresh(_ sender:AnyObject) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setBackgroundImage("sand", ofType: "png")
        
        table.isHidden = true
        loading.startAnimating()
        table.dataSource = self
        table.delegate = self
        loadData()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(TournamentListViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.table.addSubview(refreshControl)
        
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        
        if let excludes = defaults.object(forKey: filterSaveKey) {
            typesToExclude = NSSet(array: excludes as! [AnyObject])
        }
        
        TournamentsDownloader().downloadHTML(){(_data) -> Void in
            self.rawDownloadedData = _data;
            self.filterData()
        }
    }
    
    func filterData(){
        var data = self.rawDownloadedData.filter( {(tournament: Tournament) -> Bool in
            !self.typesToExclude.contains(tournament.levelCategory)
        })
        
        if(!self.typesToExclude.contains("hideOld")){
            let now = Foundation.Date()
            let currentPeriodName = TournamentListHelper().getPeriodForDate(now).name
            data = data.filter( {(tournament: Tournament) -> Bool in
                (((tournament.from as NSDate).earlierDate(now) == now ||
                    tournament.period.range(of: currentPeriodName) != nil))
            })
        }
        
        let sectionNames = NSSet(array: data.map {
            return $0.period
            }).allObjects
        
        self.results = sectionNames.map {
            let sectionName:String = $0 as! String
            return PeriodTableSection(title: sectionName, tournaments: data.filter( {(tournament: Tournament) -> Bool in
                tournament.period == sectionName
            }))
        }
        self.results.sort(by: { $0.title < $1.title })
        self.table.reloadData()
        self.table.isHidden = false
        self.loading.stopAnimating()
        self.refreshControl.endRefreshing()
        
        var label = "filtrera"
        if(typesToExclude.count > 0) {
            label = "filter(\(typesToExclude.count))"
        }
        filterLabel.setTitle(label, for: UIControlState())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        return results[numberOfRowsInSection].tournaments.count
    }
    
    func tableView(_: UITableView, cellForRowAt cellForRowAtIndexPath: IndexPath) -> UITableViewCell{
        let tournament = self.results[cellForRowAtIndexPath.section].tournaments[cellForRowAtIndexPath.row]
        var cellName = "NoInfo"
        if(tournament.moreInfo){
            cellName = "MoreInfo"
        }
        let cell = table.dequeueReusableCell(withIdentifier: cellName)
        cell?.textLabel?.text = tournament.name
            .replacingOccurrences(of: "Svart ", with:"")
            .replacingOccurrences(of: "Sv ", with:"")
            .replacingOccurrences(of: "(svart)", with:"Open")
            .replacingOccurrences(of: "(grön)", with:"Open Grön")
            .replacingOccurrences(of: "(mixed)", with:"Mixed")
            .replacingOccurrences(of: "(ch)", with:"Challenger")
            .replacingOccurrences(of: "svart ", with:"")
            .replacingOccurrences(of: "Grön ", with:"")
            .replacingOccurrences(of: "grön ", with:"")
            .replacingOccurrences(of: "lö ", with:"")
            .replacingOccurrences(of: "Lö ", with:"")
            .replacingOccurrences(of: "Må ", with:"")
            .replacingOccurrences(of: "Sö ", with:"")
            .replacingOccurrences(of: "sö ", with:"")
            .replacingOccurrences(of: "sön ", with:"")
            .replacingOccurrences(of: " den ", with:" ")
            .replacingOccurrences(of: "Svart", with:"")
            .replacingOccurrences(of: "svart", with:"")
            .replacingOccurrences(of: "Grön", with:"")
            .replacingOccurrences(of: "grön", with:"")
            .replacingOccurrences(of: " mix ", with:" Mixed ")
            .replacingOccurrences(of: " mix", with:" Mixed")
            .replacingOccurrences(of: " MIX", with:" Mixed")
            .replacingOccurrences(of: "Open Mix ", with:"Mixed ")
            .replacingOccurrences(of: "Mixed Open", with:"Mixed")
            .replacingOccurrences(of: "2018", with:"")
            .replacingOccurrences(of: "Open Mix", with:"Mixed")
            .replacingOccurrences(of: " Dam/Herr ", with:" ")
            .replacingOccurrences(of: "(open sv)", with:"Open")
            .replacingOccurrences(of: " open", with:" Open")
            .replacingOccurrences(of: " challenger", with:" Challenger")
            .replacingOccurrences(of: " mixed", with:" Mixed")
            .replacingOccurrences(of: "Garantiplats", with:"")
            .replacingOccurrences(of: "Juni ", with:" ")
            .replacingOccurrences(of: "juni ", with:" ")
            .replacingOccurrences(of: "Juli", with:"")
            .replacingOccurrences(of: "juli", with:"")
            .replacingOccurrences(of: "aug", with:"")
            .replacingOccurrences(of: "v24", with:"")
            .replacingOccurrences(of: "v25", with:"")
            .replacingOccurrences(of: "v26", with:"")
            .replacingOccurrences(of: "v27", with:"")
            .replacingOccurrences(of: "v28", with:"")
            .replacingOccurrences(of: "v29", with:"")
            .replacingOccurrences(of: "v30", with:"")
            .replacingOccurrences(of: "v31", with:"")
            .replacingOccurrences(of: "v32", with:"")
            .replacingOccurrences(of: "v33", with:"")
            .replacingOccurrences(of: "v34", with:"")
            .replacingOccurrences(of: "v35", with:"")
            .replacingOccurrences(of: "v36", with:"")
            .replacingOccurrences(of: "v37", with:"")
            .replacingOccurrences(of: "v38", with:"")
            .replacingOccurrences(of: "v39", with:"")
            .replacingOccurrences(of: "1707", with:"")
            .replacingOccurrences(of: "1708", with:"")
            .replacingOccurrences(of: "1709", with:"")
            .replacingOccurrences(of: "/6", with:"")
            .replacingOccurrences(of: "/7", with:"")
            .replacingOccurrences(of: "/8", with:"")
            .replacingOccurrences(of: "/9", with:"")
            .replacingOccurrences(of: "/10", with:"")
            .replacingOccurrences(of: "01", with:"")
            .replacingOccurrences(of: "02", with:"")
            .replacingOccurrences(of: " 2 ", with:" ")
            .replacingOccurrences(of: "03", with:"")
            .replacingOccurrences(of: " 3 ", with:" ")
            .replacingOccurrences(of: "04", with:"")
            .replacingOccurrences(of: " 4 ", with:" ")
            .replacingOccurrences(of: "05", with:"")
            .replacingOccurrences(of: " 5 ", with:" ")
            .replacingOccurrences(of: "06", with:"")
            .replacingOccurrences(of: " 6 ", with:" ")
            .replacingOccurrences(of: "07", with:"")
            .replacingOccurrences(of: " 7 ", with:" ")
            .replacingOccurrences(of: "08 Beach", with:"nollå beach")
            .replacingOccurrences(of: "08", with:"")
            .replacingOccurrences(of: "nollå beach", with:"08 Beach")
            .replacingOccurrences(of: " 8 ", with:" ")
            .replacingOccurrences(of: "09", with:"")
            .replacingOccurrences(of: " 9 ", with:" ")
            .replacingOccurrences(of: "10", with:"")
            .replacingOccurrences(of: "11", with:"")
            .replacingOccurrences(of: "12", with:"")
            .replacingOccurrences(of: "13", with:"")
            .replacingOccurrences(of: "14", with:"")
            .replacingOccurrences(of: "15", with:"")
            .replacingOccurrences(of: "16", with:"")
            .replacingOccurrences(of: "17", with:"")
            .replacingOccurrences(of: "18", with:"")
            .replacingOccurrences(of: "19", with:"")
            .replacingOccurrences(of: "20", with:"")
            .replacingOccurrences(of: "21", with:"")
            .replacingOccurrences(of: "22", with:"")
            .replacingOccurrences(of: "U23", with:"utjugotre")
            .replacingOccurrences(of: "23", with:"")
            .replacingOccurrences(of: "utjugotre", with:"U23")
            .replacingOccurrences(of: "24", with:"")
            .replacingOccurrences(of: "25", with:"")
            .replacingOccurrences(of: "26", with:"")
            .replacingOccurrences(of: "27", with:"")
            .replacingOccurrences(of: "28", with:"")
            .replacingOccurrences(of: "29", with:"")
            .replacingOccurrences(of: "30", with:"")
            .replacingOccurrences(of: "31", with:"")
            .replacingOccurrences(of: "okt ", with:" ")
            .replacingOccurrences(of: " okt", with:" ")
            .replacingOccurrences(of: "sep ", with:"")
            .replacingOccurrences(of: " sep", with:"")
            .replacingOccurrences(of: " nov", with:"")
            .replacingOccurrences(of: " dec", with:"")
            .replacingOccurrences(of: "()", with:"")
            .replacingOccurrences(of: " v ", with:" ")
        
        cell?.detailTextLabel?.text = tournament.formattedFrom + " - " + tournament.organiser
        addImage(cell!, levelCategory: tournament.levelCategory)
     
        return cell!
    }
    
    func addImage(_ cell: UITableViewCell, levelCategory: String) {
        if(levelCategory == "mixed"){
            cell.imageView?.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "blue", ofType: "png")!)
        }
        else if(levelCategory == "open grön"){
            cell.imageView?.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "green", ofType: "png")!)
        }
        else if(levelCategory == "open svart"){
            cell.imageView?.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "black", ofType: "png")!)
        }
        else if(levelCategory == "challenger"){
            cell.imageView?.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "red", ofType: "png")!)
        }
        else {
            cell.imageView?.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "normal", ofType: "png")!)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.backgroundColor = UIColor.clear
            view.textLabel!.textColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return results[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = table.indexPathForSelectedRow!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedTournament = self.results[indexPath.section].tournaments[indexPath.row]
        self.performSegue(withIdentifier: "ShowTournament", sender: self)
        table.beginUpdates()
        table.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {

        if segue.identifier == "ShowSettings" {
            let nav = segue.destination as! UINavigationController
            let filterViewController = nav.visibleViewController as! FilterSettingsViewController
            filterViewController.addSettings(typesToExclude)
            filterViewController.prepopulateSettings()
        }
    }
}
