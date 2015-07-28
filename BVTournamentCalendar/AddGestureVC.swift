//
//  AddGestureVC.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 30/06/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class AddGestureVC : UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var target = segue.destinationViewController as! RankingVC
        target.type = (self.tabBarItem.title!)
    }
}