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
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    @IBAction func sortingChanged(_ sender: AnyObject) {
        filterData()
    }
    
    @IBOutlet weak var bbi: UIBarButtonItem!
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
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        hideEmptyRows(table)
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal

        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.showsScopeBar = false
        
        searchController.searchBar.barStyle = UIBarStyle.default
        placeholder.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
        
        setBackgroundImage("skyleft", ofType: "PNG")
        
        table.dataSource = self
        table.delegate = self
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.isActive) {
            return self.searchData.count
        } else {
            return self.rawDownloadedData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.searchController.isActive && searchController.searchBar.text! != "")
        {
            let cell = table.dequeueReusableCell(withIdentifier: "SearchResult")
            let data = self.searchData[indexPath.row]
            let rank = (sortBy.selectedSegmentIndex == 0) ? data.rankByPoints : data.rankByEntryPoints
            cell?.detailTextLabel!.text = "Rankingpoäng: \(data.points), Entry points: \(data.entryPoints)"
            cell?.textLabel?.text = "\(rank) - " + data.name
            return cell!
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: "PlayerRanking")
            let data = self.rawDownloadedData[indexPath.row]
            var rank = data.rankByPoints
            if(sortBy.selectedSegmentIndex == 0) {
                cell?.detailTextLabel!.text = "\(data.points)"
            } else {
                cell?.detailTextLabel!.text = "\(data.entryPoints)"
                rank = data.rankByEntryPoints
            }
            
            cell?.textLabel?.text = "\(rank) - " + data.name
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.searchController.isActive && searchController.searchBar.text! != "") {
            return 55
        } else {
            return 33
        }
    }
    
    func loadData() {
        // Do any additional setup after loading the view, typically from a nib.
        let datatype = type == "Herr" ? "H" :
            type == "Dam" ? "D" : "M"
        
        PlayerRankingsDownloader().downloadHTML(datatype){(_data) -> Void in
            self.rawDownloadedData = _data;
            self.filterData()
        }
        self.table.isHidden = true
        self.loading.startAnimating()
    }
    
    func filterData(){
        if(sortBy.selectedSegmentIndex == 0){
            self.rawDownloadedData.sort(by: { $0.rankByPoints < $1.rankByPoints })
        } else {
            self.rawDownloadedData.sort(by: { $0.rankByEntryPoints < $1.rankByEntryPoints })
        }
        
        self.table.reloadData()
        self.table.isHidden = false
        self.loading.stopAnimating()
    }
}

extension RankingVC
{
    func updateSearchResults(for searchController: UISearchController)
    {
        if(searchController.searchBar.text! == "") {
            self.searchData = self.rawDownloadedData
        } else {
            self.searchData = self.rawDownloadedData.filter({(player:PlayerRanking) -> Bool in
                let stringMatch = player.name.lowercased().range(of: searchController.searchBar.text!.lowercased())
                return stringMatch != nil
            })
        }
    }
}

extension RankingVC: UITableViewDelegate
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let indexPath = table.indexPathForSelectedRow!
        let viewController = segue.destination as! PlayerRankingVC
        
        if segue.identifier == "ShowPlayerFromSearch" {
            viewController.addPlayer(self.searchData[indexPath.row])
        }
        
        if segue.identifier == "ShowPlayer" {
            viewController.addPlayer(self.rawDownloadedData[indexPath.row])
        }
    }
}

