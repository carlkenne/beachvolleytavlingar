//
//  PlayerRankingVC.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 14/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

struct RatingSection{
    let title: String
    let rating: Int
}

class PlayerRankingVC : UITableViewController
{
    var results = [PlayerRankingGame]()
    var summary = [RatingSection]()
    var rankingStartIndex = 7
    var entrypointsStartIndex = 1
    var noOfEnttryPoints = 5
    var snittresultatStartIndex = 0
    var player : PlayerRanking?
    
    func addPlayer(ranking:PlayerRanking){
        title = ranking.name + " (\(ranking.club))"
        player = ranking
        PlayerRankingGameListDownloader().downloadHTML(ranking.detailsUrl){(_data) -> Void in
            self.results = _data
            self.noOfEnttryPoints = self.results.filter(){ $0.isEntryPoint }.count
            self.rankingStartIndex = self.noOfEnttryPoints + 1 + self.entrypointsStartIndex
            
            var levels = NSSet(array: _data.map {
                return $0.levelCategory
            }).allObjects
                
            self.summary = levels.map {
                var sectionName:String = $0 as! String
                var rating =  RatingSection(title: sectionName, rating: self.getRating(sectionName))
                println("\(rating.title) \(rating.rating)")
                return rating
            }

            self.tableView.reloadData()
        }
    }
    
    func getRating(level: String) -> Int {
        var greens: [Float]
        
        greens = self.results.filter( {(tournament: PlayerRankingGame) -> Bool in
            tournament.levelCategory == level
        }).map {
            var tre = split($0.result) {$0 == " "}
            
            if(tre.count == 3) {
                var plats = Float(tre[0].toInt()!)
                var total = Float(tre[2].toInt()!)
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
        if(section == snittresultatStartIndex){
            return summary.count
        } else if(section == entrypointsStartIndex || section == rankingStartIndex){
            return 0
        }
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.results.count > noOfEnttryPoints) {
            return self.results.count + 3;
        } else if(self.results.count > 0) {
            return self.results.count + 2
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != entrypointsStartIndex && section != rankingStartIndex && section != snittresultatStartIndex){
            return 20
        }
        return 40
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == snittresultatStartIndex){
            return "Snittresultat"
        } else if(section == entrypointsStartIndex){
            var ep = player!.entryPoints
            
            return "Entrypoints (\(ep))"
        } else if(section == rankingStartIndex || section == self.results.count + 3){
            return "Övriga"
        } else if(section < rankingStartIndex){
            return "\(self.results[section - 2].period)  (\(self.results[section - 2].year))"
        }
        return "\(self.results[section - 3].period)  (\(self.results[section - 3].year))"
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView

        if(section == entrypointsStartIndex || section == rankingStartIndex || section == snittresultatStartIndex) {
            header.textLabel.textColor = UIColor.blackColor()
        } else {
            header.textLabel.textColor = UIColor(red:0.427451, green:0.427451, blue:0.447059, alpha: 1.0)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == snittresultatStartIndex ){
            let cell = tableView.dequeueReusableCellWithIdentifier("GameRankedSimple") as! UITableViewCell
            var rating = summary[indexPath.row]
            cell.detailTextLabel?.text = rating.title
            cell.textLabel?.text = "\(rating.rating)%"
            return cell
        }
        var index = indexPath.section > rankingStartIndex ? indexPath.section - 3 : indexPath.section - 2
        var tourney = self.results[index]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GameRanked") as! UITableViewCell
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