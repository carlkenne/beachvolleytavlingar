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
    
    @IBAction func saveFilterSettings(segue:UIStoryboardSegue) {
        if let filterSettings = segue.sourceViewController as? FilterSettingsViewController {
            
            var excludes = [String]()
            if(!filterSettings.black.on){
                excludes.append("open svart")
            }
            if(!filterSettings.green.on){
                excludes.append("open grön")
            }
            if(!filterSettings.challenger.on){
                excludes.append("challenger")
            }
            if(!filterSettings.Mixed.on){
                excludes.append("mixed")
            }
            if(!filterSettings.misc.on){
                excludes.append("övrigt")
            }
            if(!filterSettings.swedishBeachTour.on){
                excludes.append("swedish beach tour")
            }
            if(!filterSettings.sm.on){
                excludes.append("sm")
            }
            if(!filterSettings.hideOld.on){
                excludes.append("hideOld")
            }

            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(excludes, forKey: filterSaveKey)
            defaults.synchronize()
            
            typesToExclude = NSSet(array: excludes)
            filterData()
        }
    }
    
    var refreshControl:UIRefreshControl!
    
    func refresh(sender:AnyObject) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setBackgroundImage("sand", ofType: "png")
        
        table.hidden = true
        loading.startAnimating()
        table.dataSource = self
        table.delegate = self
        loadData()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(TournamentListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refreshControl)
        
    }
    
    func loadData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let excludes = defaults.objectForKey(filterSaveKey) {
            typesToExclude = NSSet(array: excludes as! [AnyObject])
        }
        
        TournamentsDownloader().downloadHTML(){(_data) -> Void in
            self.rawDownloadedData = _data;
            self.filterData()
        }
    }
    
    func filterData(){
        var data = self.rawDownloadedData.filter( {(tournament: Tournament) -> Bool in
            !self.typesToExclude.containsObject(tournament.levelCategory)
        })
        
        if(!self.typesToExclude.containsObject("hideOld")){
            let now = NSDate()
            let currentPeriodName = TournamentListHelper().getPeriodForDate(now).name
            data = data.filter( {(tournament: Tournament) -> Bool in
                ((tournament.from.earlierDate(now) == now || tournament.period.rangeOfString(currentPeriodName) != nil))
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
        self.results.sortInPlace({ $0.title < $1.title })
        self.table.reloadData()
        self.table.hidden = false
        self.loading.stopAnimating()
        self.refreshControl.endRefreshing()
        
        var label = "filtrera"
        if(typesToExclude.count > 0) {
            label = "filter(\(typesToExclude.count))"
        }
        filterLabel.setTitle(label, forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        return results[numberOfRowsInSection].tournaments.count
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell{
        let tournament = self.results[cellForRowAtIndexPath.section].tournaments[cellForRowAtIndexPath.row]
        var cellName = "NoInfo"
        if(tournament.moreInfo){
            cellName = "MoreInfo"
        }
        let cell = table.dequeueReusableCellWithIdentifier(cellName) as UITableViewCell!
        cell.textLabel?.text = tournament.name
        cell.detailTextLabel?.text = tournament.formattedFrom + " - " + tournament.organiser
        addImage(cell, levelCategory: tournament.levelCategory)
     
        return cell
    }
    
    func addImage(cell: UITableViewCell, levelCategory: String) {
        if(levelCategory == "mixed"){
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("blue", ofType: "png")!)
        }
        else if(levelCategory == "open grön"){
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("green", ofType: "png")!)
        }
        else if(levelCategory == "open svart"){
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("black", ofType: "png")!)
        }
        else if(levelCategory == "challenger"){
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("red", ofType: "png")!)
        }
        else {
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("normal", ofType: "png")!)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.blackColor()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return results[section].title
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return results.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = table.indexPathForSelectedRow!
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.selectedTournament = self.results[indexPath.section].tournaments[indexPath.row]
        self.performSegueWithIdentifier("ShowTournament", sender: self)
        table.beginUpdates()
        table.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        if segue.identifier == "ShowSettings" {
            let nav = segue.destinationViewController as! UINavigationController
            let filterViewController = nav.visibleViewController as! FilterSettingsViewController
            filterViewController.addSettings(typesToExclude)
            filterViewController.prepopulateSettings()
        }
    }
}
