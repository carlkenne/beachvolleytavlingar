//
//  FilterSettingsViewController.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 01/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit

class FilterSettingsViewController: UITableViewController {
    
    @IBOutlet weak var green: UISwitch!
    @IBOutlet weak var black: UISwitch!
    @IBOutlet weak var challenger: UISwitch!
    @IBOutlet weak var Mixed: UISwitch!
    @IBOutlet weak var hideOld: UISwitch!
    @IBOutlet weak var swedishBeachTour: UISwitch!
    @IBOutlet weak var misc: UISwitch!
    @IBOutlet weak var sm: UISwitch!
    
    var loaded:Bool = false
    var settingsToExclude = NSSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loaded = true
        prepopulateSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSettings(_ _settingsToExclude: NSSet){
        settingsToExclude = _settingsToExclude
    }
    
    func prepopulateSettings(){
        if(loaded == false){
            return
        }
        if(settingsToExclude.contains("mixed")){
            Mixed.isOn = false
        }
        if(settingsToExclude.contains("open grön")){
            green.isOn = false
        }
        if(settingsToExclude.contains("open svart")){
            black.isOn = false
        }
        if(settingsToExclude.contains("challenger")){
            challenger.isOn = false
        }
        if(settingsToExclude.contains("övrigt")){
            misc.isOn = false
        }
        if(settingsToExclude.contains("swedish beach tour")){
            swedishBeachTour.isOn = false
        }
        if(settingsToExclude.contains("sm")){
            sm.isOn = false
        }
        if(settingsToExclude.contains("hideOld")){
            hideOld.isOn = false
        }
    }
}
