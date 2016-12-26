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
                (((tournament.from as NSDate).earlierDate(now) == now || tournament.period.range(of: currentPeriodName) != nil))
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
        let cell = table.dequeueReusableCell(withIdentifier: cellName) as UITableViewCell!
        cell?.textLabel?.text = tournament.name
            .replacingOccurrences(of: "Svart ", with:"")
            .replacingOccurrences(of: "Sv ", with:"")
            .replacingOccurrences(of: "svart ", with:"")
            .replacingOccurrences(of: "Grön ", with:"")
            .replacingOccurrences(of: "grön ", with:"")
            .replacingOccurrences(of: "lö ", with:"")
            .replacingOccurrences(of: "Lö ", with:"")
            .replacingOccurrences(of: "Må ", with:"")
            .replacingOccurrences(of: "Sö ", with:"")
            .replacingOccurrences(of: "sö ", with:"")
            .replacingOccurrences(of: "Svart", with:"")
            .replacingOccurrences(of: "svart", with:"")
            .replacingOccurrences(of: "Grön", with:"")
            .replacingOccurrences(of: "grön", with:"")
            .replacingOccurrences(of: "Open Mix ", with:"Mixed")
            .replacingOccurrences(of: "Open Mix", with:"Mixed")
            .replacingOccurrences(of: " Dam/Herr ", with:" ")

            
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
