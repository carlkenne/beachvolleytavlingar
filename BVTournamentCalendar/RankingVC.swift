//
//  RankingVC.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 29/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class RankingVC : UIViewController, UITableViewDataSource, UISearchResultsUpdating
{
    @IBOutlet weak var sortBy: UISegmentedControl!
  
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var searchbarplaceholder: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    @IBAction func sortingChanged(sender: AnyObject) {
        filterData()
    }
    
    @IBOutlet weak var bbi: UIBarButtonItem!
    
    @IBOutlet weak var sbar: UISearchBar!
    
    
    @IBOutlet weak var placeholder: UIView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var rawDownloadedData = [PlayerRanking]()
    var searchData:[PlayerRanking] = [PlayerRanking](){
        didSet  {self.table.reloadData()}
    }
    
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        hideEmptyRows(table)
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .Minimal
      //  searchController.searchBar.scopeButtonTitles = [AnyObject]()

        searchController.dimsBackgroundDuringPresentation = false
       // navBar.addSubview(searchController.searchBar)
        searchController.searchBar.showsScopeBar = false
        
        searchController.searchBar.barStyle = UIBarStyle.Default
        placeholder.addSubview(searchController.searchBar)
       
      searchController.searchBar.sizeToFit()
        
        
        setBackgroundImage("skyleft", ofType: "PNG")
        
        table.dataSource = self
        table.delegate = self
        loadData()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.active)
        {
            return self.searchData.count
        } else
        {
            return self.rawDownloadedData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.searchController.active)
        {
            let cell = table.dequeueReusableCellWithIdentifier("SearchResult") as! UITableViewCell
            var data = self.searchData[indexPath.row]
            var rank = (sortBy.selectedSegmentIndex == 0) ? data.rankByPoints : data.rankByEntryPoints
            cell.detailTextLabel!.text = "Rankingpoäng: \(data.points), Entry points: \(data.entryPoints)"
            cell.textLabel?.text = "\(rank) - " + data.name
            return cell
        }
        else
        {
            let cell = table.dequeueReusableCellWithIdentifier("PlayerRanking") as! UITableViewCell
            var data = self.rawDownloadedData[indexPath.row]
            var rank = data.rankByPoints
            if(sortBy.selectedSegmentIndex == 0) {
                cell.detailTextLabel!.text = "\(data.points)"
            } else {
                cell.detailTextLabel!.text = "\(data.entryPoints)"
                rank = data.rankByEntryPoints
            }
            
            cell.textLabel?.text = "\(rank) - " + data.name
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.searchController.active) {
            return 55
        }
        else {
            return 33
        }
    }
    
    
    func loadData() {
        // Do any additional setup after loading the view, typically from a nib.
        var datatype = type == "Herr" ? "H" :
            type == "Dam" ? "D" : "M"
        
        PlayerRankingDownloader().downloadHTML(datatype){(_data) -> Void in
            self.rawDownloadedData = _data;
            self.filterData()
        }
        self.table.hidden = true
        self.loading.startAnimating()
    }
    
    func filterData(){
        if(sortBy.selectedSegmentIndex == 0){
            self.rawDownloadedData.sort({ $0.rankByPoints < $1.rankByPoints })
        } else {
            self.rawDownloadedData.sort({ $0.rankByEntryPoints < $1.rankByEntryPoints })
        }
        
        self.table.reloadData()
        self.table.hidden = false
        self.loading.stopAnimating()
    }
}

extension RankingVC: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchData = self.rawDownloadedData.filter({(player:PlayerRanking) -> Bool in
            var stringMatch = player.name.lowercaseString.rangeOfString(searchController.searchBar.text.lowercaseString)
            return stringMatch != nil
        })
    }
}

extension RankingVC: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

