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
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        var image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("normal-back", ofType: "png")!)
        image?.drawInRect(self.view.bounds, blendMode: CGBlendMode(kCGBlendModeNormal.value), alpha: 1)
        var i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: i)
        
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
        let applicants = self.dataSource[cellForRowAtIndexPath.section].applicants[cellForRowAtIndexPath.row]
        let cell = table.dequeueReusableCellWithIdentifier("Applicant") as! UITableViewCell

        cell.textLabel?.text = applicants.players
        cell.detailTextLabel?.text = "\(cellForRowAtIndexPath.row+1) (\(applicants.points())p) \(applicants.club)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = dataSource[section].title
        if( dataSource[section].title == "H" ) {
            title = "Herr"
        }
        if( dataSource[section].title == "HV" ) {
            title = "Herr Väntelista"
        }
        if( dataSource[section].title == "D" ) {
            title = "Dam"
        }
        if( dataSource[section].title == "DV" ) {
            title = "Dam Väntelista"
        }
        if( dataSource[section].title == "M" ) {
            title = "Mixed"
        }
        if( dataSource[section].title == "MV" ) {
            title = "Mixed Väntelista"
        }

        return title + " (\(dataSource[section].applicants.count))"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count;
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
                return ApplicantsTableSection(title: sectionName, applicants: listOfApplicants.filter( {(applicant: Applicants) -> Bool in
                    applicant.type == sectionName
                }))
            }
            
            self.dataSource.sort({ $0.title < $1.title })
            
            self.table.reloadData()
            self.refreshControl.endRefreshing()
            self.loading.stopAnimating()
        }
    }
}