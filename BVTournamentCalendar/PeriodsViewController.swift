//
//  FirstViewController.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit

class PeriodsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var table : UITableView!
    @IBOutlet var loading : UIActivityIndicatorView!

    var results = [PeriodTableSection]()
    var filter = FilterSettings()
    var doNotInclude = NSSet()
    
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
            
            filter = FilterSettings(
                black:filterSettings.black.on,
                green:filterSettings.green.on,
                challenger:filterSettings.challenger.on,
                mixed:filterSettings.Mixed.on,
                misc:filterSettings.misc.on)

            doNotInclude = NSSet(array: excludes)

            loadData()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        var image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("sand", ofType: "png")!)
        image?.drawInRect(self.view.bounds)
        var i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: i)
        loadData()
    }
    
    func loadData() {
        table.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
        TournamentsDownloader().downloadHTML(){(_data) -> Void in

            var data = _data.filter( {(tournament: Tournament) -> Bool in
                !self.doNotInclude.containsObject(tournament.levelCategory)
            })
            
            let sectionNames = NSSet(array: data.map {
                return $0.period
            }).allObjects

            self.results = sectionNames.map {
                var sectionName:String = $0 as String
                return PeriodTableSection(title: sectionName, tournaments: data.filter( {(tournament: Tournament) -> Bool in
                    tournament.period == sectionName
                }))
            }
            self.results.sort({ $0.title < $1.title })
            var currentPeriodName = TournamentPeriods().getPeriodNameForDate(NSDate())
            var currentPeriod = -1
            for var p = 0; p < self.results.count; p++ {
                if(self.results[p].title.rangeOfString(currentPeriodName) != nil) {
                    currentPeriod = p
                }
            }
            
            self.table.reloadData()
            self.table.hidden = false
            self.loading.stopAnimating()
            println(currentPeriod)
            if(currentPeriod > -1) {
                self.table.scrollToRowAtIndexPath(
                    NSIndexPath(forItem: 0, inSection: currentPeriod), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
        }
        
        loading.startAnimating()
        table.dataSource = self
        table.delegate = self
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
        let cell = table.dequeueReusableCellWithIdentifier(cellName) as UITableViewCell
        cell.textLabel?.text = tournament.name
        cell.detailTextLabel?.text = tournament.formattedFrom + " - " + tournament.organiser
        
        if(tournament.levelCategory == "mixed"){
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("blue", ofType: "png")!)
        }
        else if(tournament.levelCategory == "open grön"){
           cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("green", ofType: "png")!)
        }
        else if(tournament.levelCategory == "open svart"){
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("black", ofType: "png")!)
        }
        else if(tournament.levelCategory == "challenger"){
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("red", ofType: "png")!)
        }
        else {
            cell.imageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("normal", ofType: "png")!)
        }

        return cell
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
        self.performSegueWithIdentifier("ShowTournament", sender: self)
        table.beginUpdates()
        table.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ShowTournament" {
            let tournamentDetailViewController = segue.destinationViewController as TournamentViewController
            let indexPath = table.indexPathForSelectedRow()!
            var tournament = self.results[indexPath.section].tournaments[indexPath.row]
            
            tournamentDetailViewController.title = tournament.name
            tournamentDetailViewController.tournament = tournament
            tournamentDetailViewController.showTournament()
        }
        if segue.identifier == "ShowSettings" {
            let nav = segue.destinationViewController as UINavigationController
            let filterViewController = nav.visibleViewController as FilterSettingsViewController
            filterViewController.addSettings(doNotInclude)
            filterViewController.prepopulateSettings()
        }
    }
}
