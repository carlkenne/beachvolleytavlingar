//
//  FirstViewController.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit

class PeriodsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table : UITableView!
    @IBOutlet weak var loading : UIActivityIndicatorView!

    @IBOutlet weak var Open: UIBarButtonItem!
    var results = [PeriodTableSection]()
    var filter = FilterSettings()
    var doNotInclude = NSSet()
    var rawDownloadedData = [Tournament]()
    
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
                excludes.append("misc")
            }
            if(!filterSettings.hideOld.on){
                excludes.append("hideOld")
            }

            doNotInclude = NSSet(array: excludes)

            filterData()
        }

    }
    
    var refreshControl:UIRefreshControl!
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        setBackgroundImage("sand", ofType: "png")
        
        table.hidden = true
        loading.startAnimating()
        table.dataSource = self
        table.delegate = self
        loadData()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refreshControl)
    }
    
    func loadData() {
        // Do any additional setup after loading the view, typically from a nib.
        TournamentsDownloader().downloadHTML(){(_data) -> Void in
            self.rawDownloadedData = _data;
            self.filterData()
        }
    }
    
    func filterData(){
        var data = self.rawDownloadedData.filter( {(tournament: Tournament) -> Bool in
            !self.doNotInclude.containsObject(tournament.levelCategory)
        })
        
        if(!self.doNotInclude.containsObject("hideOld")){
            var now = NSDate()
            var currentPeriodName = TournamentPeriods().getPeriodNameForDate(NSDate())
            data = data.filter( {(tournament: Tournament) -> Bool in
                tournament.from.earlierDate(now) == now || tournament.period.rangeOfString(currentPeriodName) != nil
            })
        }
        
        let sectionNames = NSSet(array: data.map {
            return $0.period
            }).allObjects
        
        self.results = sectionNames.map {
            var sectionName:String = $0 as! String
            return PeriodTableSection(title: sectionName, tournaments: data.filter( {(tournament: Tournament) -> Bool in
                tournament.period == sectionName
            }))
        }
        self.results.sort({ $0.title < $1.title })
        self.table.reloadData()
        self.table.hidden = false
        self.loading.stopAnimating()
        self.refreshControl.endRefreshing()
        
        var currentPeriod = self.getCurrentPeriod()
        if(currentPeriod > -1) {
            self.table.scrollToRowAtIndexPath(
                NSIndexPath(forItem: 0, inSection: currentPeriod), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    
    func getCurrentPeriod() -> Int{
        var currentPeriodName = TournamentPeriods().getPeriodNameForDate(NSDate())
        for var p = 0; p < self.results.count; p++ {
            if(self.results[p].title.rangeOfString(currentPeriodName) != nil) {
                return p
            }
        }
        return -1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    //UIViewTableDataSource
    //
    func tableView(UITableView, numberOfRowsInSection: Int) -> Int {
        return results[numberOfRowsInSection].tournaments.count
    }
    
    func tableView(UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell{
        let tournament = self.results[cellForRowAtIndexPath.section].tournaments[cellForRowAtIndexPath.row]
        var cellName = "NoInfo"
        if(tournament.moreInfo){
            cellName = "MoreInfo"
        }
        let cell = table.dequeueReusableCellWithIdentifier(cellName) as! UITableViewCell
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
            view.textLabel.backgroundColor = UIColor.clearColor()
            view.textLabel.textColor = UIColor.blackColor()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return results[section].title
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return results.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = table.indexPathForSelectedRow()!
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
            filterViewController.addSettings(doNotInclude)
            filterViewController.prepopulateSettings()
        }
    }
}
