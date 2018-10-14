//
//  MapViewController.swift
//  BVTournamentCalendar
//
//  Created by Wilhelm Fors on 13/03/17.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import UIKit
import MapKit

class CourtMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(10, 10)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(60.492579), CLLocationDegrees(15.286471))
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.map.setRegion(region, animated: true)
            
        self.map.showsUserLocation = true
    }
}
