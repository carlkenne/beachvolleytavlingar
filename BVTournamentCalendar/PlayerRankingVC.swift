//
//  PlayerRankingVC.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 14/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

struct SnittresultatCell {
    let title: String
    let rating: Int
}

struct UpcomingCell {
    let period: Int
    let entrypoint: Int
    let numberOfTournaments: Int
}

struct PlayerRankingViewModel {
    let snittresultatStartIndex = 0
    var snittresultatList = [SnittresultatCell]()
    
    var entrypointsStartIndex = -1
    var entrypointsList = [PlayerRankingGame]()
    
    var rankingpointsStartIndex = -1
    var rankingpointsList = [PlayerRankingGame]()
    
    var remainingRankingsStartIndex = -1
    var remainingRankings = [UpcomingCell]()
}

class PlayerRankingVC : UITableViewController
{
    var viewModel = PlayerRankingViewModel()
    var results = PlayerRankingDetails( games :[PlayerRankingGame](), age:0 )
    
    var player : PlayerRanking?
    
    func addPlayer(ranking:PlayerRanking) {
        player = ranking
        PlayerRankingGameListDownloader().downloadHTML(ranking.detailsUrl){(_data) -> Void in
            
            self.results = _data
            if(self.results.age > 0 ){
                self.title = ranking.name + " (\(self.results.age)år, \(ranking.club))"
            } else {
                self.title = ranking.name + " (\(ranking.club))"
            }
            let entrypointsList = self.results.games.filter(){ $0.isEntryPoint }
            let rankingpointsList = self.results.games.filter(){ !$0.isEntryPoint }
            let entrypointsStartIndex = 1
            let rankingStartIndex = entrypointsList.count + entrypointsStartIndex + 1
            let remainingRankingsStartIndex = rankingpointsList.count + rankingStartIndex + 1
            
            let levels = NSSet(array: self.results.games.map {
                return $0.levelCategory
            }).allObjects
                
            let snittresultatList = levels.map {
                let sectionName:String = $0 as! String
                let rating =  SnittresultatCell(title: sectionName, rating: self.getRating(sectionName))
                return rating
            }.filter( {(rating: SnittresultatCell) -> Bool in
                rating.rating > 0
            })
            
            let now = min(TournamentListHelper().getCurrentPeriod()+1, 16)
            var remainingList = [UpcomingCell]()
            
            for index in now...16 {
                
                var start = index-10
                var year = 2016
                if(start <= 0){
                    start = 16 + start
                    year = 2015
                }
                var topRankings = self.results.games.filter( {(ranking: PlayerRankingGame) -> Bool in
                    if(Int(ranking.year)! < year) {
                        return false
                    }
                    if(Int(ranking.year)! == year && ranking.periodInt >= start) {
                        return true
                    }
                    return Int(ranking.year)! > year
                })
                topRankings.sortInPlace ({ $0.points > $1.points })
                
                let n = min(5, topRankings.count)
                let total = topRankings[0..<n]
                    .map({
                        return $0.points
                    })
                    .reduce(0){ $0 + $1 }
            
                let upcoming = UpcomingCell(
                    period: index,
                    entrypoint: total,
                    numberOfTournaments: n
                )
                if(remainingList.count > 0){
                    if(remainingList[remainingList.count-1].entrypoint != upcoming.entrypoint) {
                        print("TP: \(index)")
                        topRankings[0..<n]
                            .map({
                                print($0)
                            })

                        
                        remainingList.append(upcoming)
                    }
                } else {
                    remainingList.append(upcoming)
                }
            }

            self.viewModel = PlayerRankingViewModel(
                snittresultatList: snittresultatList,
                
                entrypointsStartIndex: entrypointsStartIndex,
                entrypointsList: entrypointsList,
                
                rankingpointsStartIndex: rankingStartIndex,
                rankingpointsList: rankingpointsList,
                
                remainingRankingsStartIndex: remainingRankingsStartIndex,
                remainingRankings: remainingList
            )
            
            self.tableView.reloadData()
        }
    }
    
    func getRating(level: String) -> Int {
        var greens: [Float]
        
        greens = self.results.games.filter( {(tournament: PlayerRankingGame) -> Bool in
            tournament.levelCategory == level
        }).map {
            var tre = $0.result.characters.split {$0 == " "}.map { String($0) }
            
            if(tre.count == 3) {
                var plats = Float(Int(tre[0])!)
                var total = Float(Int(tre[2])!)
                total = total - floor(total / 4) // cut off the bottom percentile since it's never really counted
                plats = min(plats, total)
                return round((total - plats) / (total - 1) * 100)
            }
            return 0
        }
        return Int(greens.reduce(0,combine: +) / Float(greens.count))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == viewModel.snittresultatStartIndex){
            return viewModel.snittresultatList.count
        } else if(section == viewModel.entrypointsStartIndex ||
            section == viewModel.rankingpointsStartIndex) {
            return 0
        } else if (section == viewModel.remainingRankingsStartIndex){
            return viewModel.remainingRankings.count + 1
        }
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.results.games.count > 0) {
            return self.results.games.count + 4;
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != viewModel.entrypointsStartIndex &&
            section != viewModel.rankingpointsStartIndex &&
            section != viewModel.snittresultatStartIndex &&
            section != viewModel.remainingRankingsStartIndex) {
            return 20
        }
        return 40
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == viewModel.remainingRankingsStartIndex && indexPath.row == 0) {
            return 20
        }
        return 40
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == viewModel.snittresultatStartIndex){
            return "Snittresultat"
        } else if(section == viewModel.entrypointsStartIndex){
            let entryPoints = player!.entryPoints
            return "Entrypoints (\(entryPoints))"
        } else if(section == viewModel.rankingpointsStartIndex){
            return "Övriga"
        } else if(section == viewModel.remainingRankingsStartIndex) {
            return "Hur länge varar alla entrypoints?"
        } else if(section < viewModel.rankingpointsStartIndex){
            return "\(self.results.games[section - 2].period)  (\(self.results.games[section - 2].year))"
        }
        return "\(self.results.games[section - 3].period)  (\(self.results.games[section - 3].year))"
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView

        if(section == viewModel.entrypointsStartIndex ||
            section == viewModel.rankingpointsStartIndex ||
            section == viewModel.snittresultatStartIndex ||
            section == viewModel.remainingRankingsStartIndex) {
            
            header.textLabel!.textColor = UIColor.blackColor()
        } else {
            header.textLabel!.textColor = UIColor(red:0.427451, green:0.427451, blue:0.447059, alpha: 1.0)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == viewModel.snittresultatStartIndex) {
            let cell = tableView.dequeueReusableCellWithIdentifier("GameRankedSimple") as UITableViewCell!
            let rating = viewModel.snittresultatList[indexPath.row]
            cell.detailTextLabel?.text = rating.title
            cell.textLabel?.text = "\(rating.rating)%"
            return cell
        }
        if(indexPath.section == viewModel.remainingRankingsStartIndex) {
            let cell = tableView.dequeueReusableCellWithIdentifier("Upcoming") as UITableViewCell!
            if(indexPath.row == 0) {
                cell.detailTextLabel?.text = "entrypoints"
                cell.textLabel?.text = "tävlingsperiod"
            } else {
                let ranking = viewModel.remainingRankings[indexPath.row-1]
                
                var extraText = "(\(ranking.numberOfTournaments) tävlingar)"
                if(ranking.numberOfTournaments == 0){
                    extraText = ""
                }
                if(ranking.numberOfTournaments == 1){
                    extraText = "(1 tävling)"
                }
                
                cell.detailTextLabel?.text = "\(ranking.entrypoint) \(extraText)"
                cell.textLabel?.text = "TP \(ranking.period)"
            }
            return cell
        }
        let index = indexPath.section > viewModel.rankingpointsStartIndex ? indexPath.section - 3 : indexPath.section - 2
        let tourney = self.results.games[index]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GameRanked") as UITableViewCell!
        cell.textLabel?.text = "plats: \(tourney.result) - (\(tourney.points) poäng)"
        cell.detailTextLabel?.text = "\(tourney.name)"
        addImage(cell, levelCategory: tourney.levelCategory)
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
}