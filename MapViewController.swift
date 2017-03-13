//
//  MapViewController.swift
//  BVTournamentCalendar
//
//  Created by Wilhelm Fors on 13/03/17.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tournament = appDelegate.selectedTournament
        let details = appDelegate.selectedTournamentDetail
        let arena = details!.arena
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.2, 0.2)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(arena.lat), CLLocationDegrees(arena.long))
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = arena.name
        annotation.subtitle = "\((tournament?.name)!), \((tournament?.organiser)!)"
        self.map.addAnnotation(annotation)
        
        self.map.showsUserLocation = true
    }

}
