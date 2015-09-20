//
//  TournamentApplicantsViewController.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 12/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit
import Foundation

class TournamentApplicantsViewController: UIViewController, UITableViewDataSource
{
    @IBOutlet weak var loading : UIActivityIndicatorView!
    var dataSource = [ApplicantsTableSection]()
    
    @IBOutlet weak var table: UITableView!
    
    var refreshControl:UIRefreshControl!
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        showTournament()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        self.table.dataSource = self
        showTournament()
        
        setBackgroundImage("normal-back", ofType: "png")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refreshControl)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        return dataSource[numberOfRowsInSection].applicants.count
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell{
        let applicants = self.dataSource[cellForRowAtIndexPath.section].applicants[cellForRowAtIndexPath.row]
        var cell : UITableViewCell
        if(applicants.type == "D"){
            cell = table.dequeueReusableCellWithIdentifier("ApplicantDam") as UITableViewCell!
        } else if (applicants.type == "H"){
            cell = table.dequeueReusableCellWithIdentifier("ApplicantHerr") as UITableViewCell!
        } else {
            cell = table.dequeueReusableCellWithIdentifier("Applicant") as UITableViewCell!
        }
        cell.textLabel?.text = applicants.players
        cell.detailTextLabel?.text = "\(cellForRowAtIndexPath.row+1) (\(applicants.points())p) \(applicants.club)"
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title + " (\(dataSource[section].applicants.count))"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count;
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController!.navigationItem.rightBarButtonItem = nil;
    }
    
    func showTournament(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let tournament = appDelegate.selectedTournament
        parentViewController?.title = tournament?.name
        
        TournamentApplicantsDownloader().downloadHTML(tournament!, detail: appDelegate.selectedTournamentDetail){
            (data) -> Void in
            var listOfApplicants = data
            listOfApplicants.sortInPlace({ $0.points() > $1.points() })
            
            let sectionNames = NSSet(array: listOfApplicants.map {
                return $0.type
            }).allObjects
            
            self.dataSource = sectionNames.map {
                let sectionName:String = $0 as! String
                var list = listOfApplicants.filter( {(applicant: Applicants) -> Bool in
                    applicant.type == sectionName
                })
                return ApplicantsTableSection(isSlider:false, title: list[0].getTypeName(), applicants: list)
            }
            
            if(self.dataSource.count == 0) {
                self.dataSource = [
                    ApplicantsTableSection(isSlider:false, title: "Inga lag är anmälda ännu", applicants: [])
                ]
            }
            
            self.dataSource.sortInPlace({ $0.title < $1.title })
            
            self.table.reloadData()
            self.refreshControl.endRefreshing()
            self.loading.stopAnimating()
        }
    }
}

class GroupSize : UITableViewCell
{
    @IBOutlet weak var groupsSlider: UISlider!
    @IBOutlet weak var groupsText: UITextField!
    
    func sliderMoved(sender: UISlider) {
        print(sender, terminator: "")
        let round = roundf(sender.value)
        sender.value = round
        groupsText.text = "\(Int(round))"
    }
}