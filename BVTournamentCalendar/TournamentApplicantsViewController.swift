//
//  TournamentApplicantsViewController.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 12/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit
import Foundation

class GroupSize : UITableViewCell
{
    @IBOutlet weak var groupsSlider: UISlider!
    @IBOutlet weak var groupsText: UITextField!
    
    func sliderMoved(sender: UISlider) {
        print(sender)
        var round = roundf(sender.value)
        sender.value = round
        groupsText.text = "\(Int(round))"
    }
}

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
    
    func tableView(UITableView, numberOfRowsInSection: Int) -> Int {
        return dataSource[numberOfRowsInSection].applicants.count
    }
    
    func tableView(UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell{
        /*if(cellForRowAtIndexPath.row == 0){
            //table.registerClass(GroupSize, forCellReuseIdentifier: <#String#>)
            //table.dequ
            var cell = table.dequeueReusableCellWithIdentifier("Group size") as! UITableViewCell
            let slider = cell.viewWithTag(1) as! UISlider
            slider.addTarget(cell, action: "sliderMoved:", forControlEvents: .ValueChanged)
          return cell
        }*/
        
        let applicants = self.dataSource[cellForRowAtIndexPath.section].applicants[cellForRowAtIndexPath.row]
        let cell = table.dequeueReusableCellWithIdentifier("Applicant") as! UITableViewCell

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
        var tournament = appDelegate.selectedTournament
        parentViewController?.title = tournament?.name
        
        TournamentApplicantsDownloader().downloadHTML(tournament!, detail: appDelegate.selectedTournamentDetail){
            (data) -> Void in
            var listOfApplicants = data
            listOfApplicants.sort({ $0.points() > $1.points() })
            
            let sectionNames = NSSet(array: listOfApplicants.map {
                return $0.type
            }).allObjects
            
            self.dataSource = sectionNames.map {
                var sectionName:String = $0 as! String
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
            
            self.dataSource.sort({ $0.title < $1.title })
            
            self.table.reloadData()
            self.refreshControl.endRefreshing()
            self.loading.stopAnimating()
        }
    }
}