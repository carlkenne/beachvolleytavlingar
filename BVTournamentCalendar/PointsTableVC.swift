//
//  PointsTableVC.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 13/07/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class PointsTableViewController: UIViewController, UITableViewDataSource {
    
    var dataSource = [PointsTableSection]()
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        showTournament()
        navigationController?.navigationBar.opaque = true
        hideEmptyRows(table)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].pointsTable.count
    }
    
    func showTournament() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let tournament = appDelegate.selectedTournament
        parentViewController?.title = tournament?.name
        loading.startAnimating()
        TournamentApplicantsDownloader().downloadHTML(tournament!, detail: appDelegate.selectedTournamentDetail){
            (data) -> Void in
            let listOfApplicants = data
            
            let dam = listOfApplicants.filter({ $0.type == "D" })
            let herr = listOfApplicants.filter({ $0.type == "H" })
            let mixed = listOfApplicants.filter({ $0.type == "M" })
            
            self.addPointsFor(dam, tournament: tournament!)
            self.addPointsFor(herr, tournament: tournament!)
            self.addPointsFor(mixed, tournament: tournament!)
            
            if(listOfApplicants.count == 0) {
                self.dataSource.append(
                    PointsTableSection(
                        title: "Inga lag är anmälda ännu",
                        pointsTable: [])
                )
            }
            
            self.table.reloadData()
            self.loading.stopAnimating()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        cell.textLabel?.text = dataSource[cellForRowAtIndexPath.section].pointsTable[cellForRowAtIndexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
    
    func addPointsFor(listOfApplicants: [Applicants], tournament: Tournament) {
        if(listOfApplicants.count == 0) { return }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let count = listOfApplicants.count > appDelegate.selectedTournamentDetail?.maxNoOfParticipants ? appDelegate.selectedTournamentDetail?.maxNoOfParticipants : listOfApplicants.count
        
        let pointTable = getPointsForLevel(count!, tournament: tournament)
        var rank = ["1:a", "2:a", "3:dje", "5:e", "9:de", "13:de", "17:de", "25:e", "33:dje", "49:de"]
        var rankShort = ["1:a", "2:a", "3:dje", "5:e", "7:de", "9:de", "13:de"] //used for SBT etc..


        
        dataSource.append(
            PointsTableSection(
                title: "\(listOfApplicants[0].getTypeName()) (\(pointTable.title))",
                pointsTable: pointTable.table.enumerate().map(){ (index: Int, element:Int) in
                    let rankTitle = ((index == 4 && listOfApplicants.count < 9) || (tournament.levelCategory == "swedish beach tour" )) ? rankShort[index]
                        : rank[index]
                    return " \(rankTitle) - \(element) poäng"
                }
            ))
        
    }
    
    func getPointsForLevel(noOfApplicants: Int, tournament: Tournament) -> PointTable {
        let greenPointsTemplate = [[10,6,4,2,1],[15,9,6,3,2,1],[20,12,8,4,3,2,1],[23,14,9,5,3,2,1,1],[28,17,11,7,4,3,2,1,1],[38,23,15,10,7,5,3,2,1,1]]
        let blackPointsTemplate = [[20,12,7,3,1],[30,18,11,6,4,1],[40,24,15,8,5,3,1],[45,27,17,10,6,4,2,1],[55,33,21,13,8,5,3,2,1],[75,45,29,19,13,9,6,4,2,1]]
        let challengerPointsTemplate = [[150,90,55,30,15],[150,100,65,40,15],[160,105,70,45,30,15]]
        let mixedPointsTemplate = [[30,18,10,6,1],[40,24,14,5,2,1],[60,36,22,8,5,3,2,1],[60,36,22,8,5,3,2,1],[100,60,36,22,13,11,8,5,3,1]]
        let sbtPointsTemplate = [[1000,600,360,180,80],[1000,600,360,200,110,70],[1000,650,400,240,150,100,60]]
        
        var pointsTemplate = [[0]]
        
        if(tournament.levelCategory == "open grön") {
            pointsTemplate = greenPointsTemplate
        } else if(tournament.levelCategory == "open svart") {
            pointsTemplate = blackPointsTemplate
        } else if(tournament.levelCategory == "challenger") {
            pointsTemplate = challengerPointsTemplate
        } else if(tournament.levelCategory == "mixed") {
            pointsTemplate = mixedPointsTemplate
        } else if(tournament.levelCategory == "swedish beach tour") {
            pointsTemplate = sbtPointsTemplate
        } else {
            return PointTable(table:[], title: "Det krävs minst 6 lag för poäng")
        }
        
        
        if(tournament.levelCategory == "swedish beach tour"){
            if(noOfApplicants < 9) {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 0), title: "6 - 8")
            } else if(noOfApplicants < 13) {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 1), title: "9 - 12")
            } else if(noOfApplicants < 17) {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 2), title: "13 - 16")
            }
        } else if(noOfApplicants > 5) {
            if(noOfApplicants < 9) {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 0), title: "6 - 8")
            } else if(noOfApplicants < 17) {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 1), title: "9 - 16")
            } else if(noOfApplicants < 25) {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 2), title: "17 - 24")
            } else if(noOfApplicants < 33) {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 3), title: "25 - 32")
            } else if(noOfApplicants < 49) {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 4), title: "33 - 48")
            } else {
                return PointTable(table: getValueOrHighest(pointsTemplate, index: 5), title: "49 - ")
            }
        }
        return PointTable(table:[], title: "Det krävs minst 6 lag för poäng")
    }
    
    func getValueOrHighest(list:[[Int]], index:Int) -> [Int]{
        if(list.count > index){
            return list[index]
        }
        return list[list.count-1]
    }
}



