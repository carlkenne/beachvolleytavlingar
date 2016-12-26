//
//  FirstViewController.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIGraphicsBeginImageContext(self.view.frame.size)
        let image = UIImage(contentsOfFile: Bundle.main.path(forResource: "sand", ofType: "png")!)
        image?.draw(in: self.view.bounds)
        let i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: i!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



