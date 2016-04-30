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
    
    let _1 = "1:a"
    let _2 = "2:a"
    let _3 = "3:e"
    let _4 = "4:e"
    let _5 = "5:e"
    let _7 = "7:e"
    let _9 = "9:de"
    let _10 = "10:e"
    let _11 = "11:e"
    let _13 = "13:e"
    let _14 = "14:e"
    let _15 = "15:e"
    let _16 = "16:e"
    let _17 = "17:e"
    let _25 = "25:e"
    let _33 = "33:e"
    let _49 = "49:e"
    
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
        
        TournamentApplicantsDownloader().downloadHTML(tournament!, detail: appDelegate.selectedTournamentDetail) {
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
        
        dataSource.append(
            PointsTableSection(
                title: "\(listOfApplicants[0].getTypeName()) (\(pointTable.title))",
                pointsTable: pointTable.table.enumerate().map(){ (index: Int, element:PointsRank) in
                    return " \(element.rank) - \(element.points) poäng"
                }
            ))
    }
    
    func getValueOrHighest(list:[[Int]], index:Int) -> [Int]{
        if(list.count > index){
            return list[index]
        }
        return list[list.count-1]
    }
    
    
    func getPointsForLevel(noOfApplicants: Int, tournament: Tournament) -> PointTable {
        
        if(tournament.levelCategory == "swedish beach tour"){
            if(noOfApplicants >=  17) {
                let points = [
                    PointsRank(points:1000, rank: _1),
                    PointsRank(points:650, rank: _2),
                    PointsRank(points:450, rank: _3),
                    PointsRank(points:270, rank: _5),
                    PointsRank(points:200, rank: _7),
                    PointsRank(points:150, rank: _9),
                    PointsRank(points:120, rank: _13),
                    PointsRank(points:80, rank: _17),
                    PointsRank(points:40, rank: _25),
                ]
                
                return PointTable(table: points, title: "17 - 32")
            }
            if(noOfApplicants >=  13) {
                let points = [
                    PointsRank(points:1000, rank: _1),
                    PointsRank(points:650, rank: _2),
                    PointsRank(points:400, rank: _3),
                    PointsRank(points:240, rank: _5),
                    PointsRank(points:150, rank: _7),
                    PointsRank(points:100, rank: _9),
                    PointsRank(points:50, rank: _13)
                    ]
                
                 return PointTable(table: points, title: "13 - 16")
            }
            if(noOfApplicants >= 9) {
                let points = [
                    PointsRank(points:1000, rank: _1),
                    PointsRank(points:650, rank: _2),
                    PointsRank(points:360, rank: _3),
                    PointsRank(points:200, rank: _5),
                    PointsRank(points:110, rank: _7),
                    PointsRank(points:70, rank: _9)
                ]
                return PointTable(table: points, title: "9 - 12")
            }
            let points = [
                PointsRank(points:1000, rank: _1),
                PointsRank(points:650, rank: _2),
                PointsRank(points:360, rank: _3),
                PointsRank(points:180, rank: _5),
                PointsRank(points:80, rank: _7)
            ]
            return PointTable(table: points, title: "6 - 8")
        }
        
        if(tournament.levelCategory == "challenger") {
            if(noOfApplicants >=  13) {
                let points = [
                    PointsRank(points:160, rank: _1),
                    PointsRank(points:105, rank: _2),
                    PointsRank(points:70, rank: _3),
                    PointsRank(points:45, rank: _5),
                    PointsRank(points:32, rank: _9),
                    PointsRank(points:24, rank: _11),
                    PointsRank(points:16, rank: _13),
                    PointsRank(points:10, rank: _15),
                ]
                return PointTable(table: points, title: "13 - 16")
            }
            let points = [
                PointsRank(points:150, rank: _1),
                PointsRank(points:90, rank: _2),
                PointsRank(points:55, rank: _3),
                PointsRank(points:30, rank: _5),
                PointsRank(points:25, rank: _7),
                PointsRank(points:20, rank: _9),
                PointsRank(points:10, rank: _10)
            ]
            return PointTable(table: points, title: "9 - 12")
        }
        
        if(tournament.levelCategory == "mixed") {
            if(noOfApplicants >=  33) {
                let points = [
                    PointsRank(points:100, rank: _1),
                    PointsRank(points:60, rank: _2),
                    PointsRank(points:36, rank: _3),
                    PointsRank(points:20, rank: _4),
                    PointsRank(points:13, rank: _5),
                    PointsRank(points:11, rank: _9),
                    PointsRank(points:8, rank: _13),
                    PointsRank(points:5, rank: _17),
                    PointsRank(points:3, rank: _25),
                    PointsRank(points:1, rank: _33),
                ]
                return PointTable(table: points, title: "33 -")
            }
            if(noOfApplicants >=  17) {
                let points = [
                    PointsRank(points:60, rank: _1),
                    PointsRank(points:36, rank: _2),
                    PointsRank(points:22, rank: _3),
                    PointsRank(points:13, rank: _4),
                    PointsRank(points:8, rank: _5),
                    PointsRank(points:5, rank: _9),
                    PointsRank(points:3, rank: _13),
                    PointsRank(points:2, rank: _17),
                    PointsRank(points:1, rank: _25),
                ]
                return PointTable(table: points, title: "17 - 32")
            }
            if(noOfApplicants >=  9) {
                let points = [
                    PointsRank(points:40, rank: _1),
                    PointsRank(points:24, rank: _2),
                    PointsRank(points:14, rank: _3),
                    PointsRank(points:9, rank: _4),
                    PointsRank(points:5, rank: _5),
                    PointsRank(points:2, rank: _9),
                    PointsRank(points:1, rank: _13)
                ]
                return PointTable(table: points, title: "9 - 16")
            }
            if(noOfApplicants >=  6) {
                let points = [
                    PointsRank(points:30, rank: _1),
                    PointsRank(points:18, rank: _2),
                    PointsRank(points:10, rank: _3),
                    PointsRank(points:6, rank: _4),
                    PointsRank(points:1, rank: _5)
                ]
                return PointTable(table: points, title: "6 - 8")
            }
            let points = [
                PointsRank(points:20, rank: _1),
                PointsRank(points:12, rank: _2),
                PointsRank(points:7, rank: _3),
                PointsRank(points:4, rank: _4),
                PointsRank(points:1, rank: _5)
            ]
            return PointTable(table: points, title: " - 5")

        }
        

        
        let greenPointsTemplate = [
            [10, 6, 4, 2, 1],
            [15, 9, 6, 3, 2, 2, 1, 1 ,1],
            [20,12, 8, 4, 3, 2, 1, 1],
            [23,14, 9, 5, 3, 2, 1, 1],
            [28,17,11, 7, 4, 3, 2, 1, 1],
            [38,23,15,10, 7, 5, 3, 2, 1, 1]]
        let blackPointsTemplate = [
            [20,12, 7, 3, 1],
            [30,18,11, 6, 5, 4, 3, 2, 1],
            [40,24,15, 8, 5, 3, 2, 1],
            [45,27,17,10, 6, 4, 2, 1],
            [55,33,21,13, 8, 5, 3, 2, 1],
            [75,45,29,19,13, 9, 6, 4, 2, 1]]
        
        var open = [[0]]
        if(tournament.levelCategory == "open grön") {
            open = greenPointsTemplate
        } else if(tournament.levelCategory == "open svart") {
            open = blackPointsTemplate
        }
        
        if(noOfApplicants >= 49) {
            let points = [
                PointsRank(points:open[5][0], rank: _1),
                PointsRank(points:open[5][1], rank: _2),
                PointsRank(points:open[5][2], rank: _3),
                PointsRank(points:open[5][3], rank: _5),
                PointsRank(points:open[5][4], rank: _9),
                PointsRank(points:open[5][5], rank: _13),
                PointsRank(points:open[5][6], rank: _17),
                PointsRank(points:open[5][7], rank: _25),
                PointsRank(points:open[5][8], rank: _33),
                PointsRank(points:open[5][9], rank: _49)
            ]
            return PointTable(table: points, title: "49 -")
        }
        if(noOfApplicants >= 33) {
            let points = [
                PointsRank(points:open[4][0], rank: _1),
                PointsRank(points:open[4][1], rank: _2),
                PointsRank(points:open[4][2], rank: _3),
                PointsRank(points:open[4][3], rank: _5),
                PointsRank(points:open[4][4], rank: _9),
                PointsRank(points:open[4][5], rank: _13),
                PointsRank(points:open[4][6], rank: _17),
                PointsRank(points:open[4][7], rank: _25),
                PointsRank(points:open[4][8], rank: _33)
            ]
            return PointTable(table: points, title: "33 - 48")
        }
        if(noOfApplicants >= 25) {
            let points = [
                PointsRank(points:open[3][0], rank: _1),
                PointsRank(points:open[3][1], rank: _2),
                PointsRank(points:open[3][2], rank: _3),
                PointsRank(points:open[3][3], rank: _5),
                PointsRank(points:open[3][4], rank: _9),
                PointsRank(points:open[3][5], rank: _13),
                PointsRank(points:open[3][6], rank: _17),
                PointsRank(points:open[3][7], rank: _25)
            ]
            return PointTable(table: points, title: "25 - 32")
        }
        if(noOfApplicants >= 17) {
            let points = [
                PointsRank(points:open[2][0], rank: _1),
                PointsRank(points:open[2][1], rank: _2),
                PointsRank(points:open[2][2], rank: _3),
                PointsRank(points:open[2][3], rank: _5),
                PointsRank(points:open[2][4], rank: _9),
                PointsRank(points:open[2][5], rank: _13),
                PointsRank(points:open[2][6], rank: _14),
                PointsRank(points:open[2][7], rank: _16)
            ]
            return PointTable(table: points, title: "17 - 24")
        }
        if(noOfApplicants >= 9) {
            let points = [
                PointsRank(points:open[1][0], rank: _1),
                PointsRank(points:open[1][1], rank: _2),
                PointsRank(points:open[1][2], rank: _3),
                PointsRank(points:open[1][3], rank: _5),
                PointsRank(points:open[1][4], rank: _7),
                PointsRank(points:open[1][5], rank: _9),
                PointsRank(points:open[1][6], rank: _10),
                PointsRank(points:open[1][7], rank: _11),
                PointsRank(points:open[1][8], rank: _13),
            ]
            return PointTable(table: points, title: "9 - 16")
        }
        let points = [
            PointsRank(points:open[0][0], rank: _1),
            PointsRank(points:open[0][1], rank: _2),
            PointsRank(points:open[0][2], rank: _3),
            PointsRank(points:open[0][3], rank: _5),
            PointsRank(points:open[0][4], rank: _7)
        ]
        return PointTable(table: points, title: "6 - 8")
    }
}



