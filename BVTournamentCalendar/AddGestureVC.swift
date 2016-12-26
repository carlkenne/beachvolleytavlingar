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
        //navigationController?.navigationBarHidden = true;
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as! RankingVC
        target.type = (self.tabBarItem.title!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
