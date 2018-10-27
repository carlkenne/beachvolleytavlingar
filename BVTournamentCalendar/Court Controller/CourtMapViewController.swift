//
//  MapViewController.swift
//  BVTournamentCalendar
//
//  Created by Wilhelm Fors on 13/03/17.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class CourtMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var myLocation:CLLocationCoordinate2D?
    
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    var userLocationSet: Bool = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(!userLocationSet) {
            let span: MKCoordinateSpan = MKCoordinateSpanMake(2, 2)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(locations[0].coordinate, span)
            map.setRegion(region, animated: true)
            userLocationSet = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        locationManager.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        var region: MKCoordinateRegion;
        
        if let location = map.userLocation.location?.coordinate {
            print("nolocation")
            region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(10, 10))
            userLocationSet = true
        } else {
            let sweCenter = CLLocationCoordinate2DMake(CLLocationDegrees(60.492579), CLLocationDegrees(15.286471))
            region = MKCoordinateRegionMake(sweCenter, MKCoordinateSpanMake(10, 10))
            userLocationSet = false
        }
        
        map.setRegion(region, animated: true)
        
        // get data
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("courts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let courtList = snapshot.value as? NSDictionary
            
            for (_, value) in courtList! {
                let loc = Location(with: value as! [String: Any])
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(loc.lat), CLLocationDegrees(loc.lng))
                annotation.title = loc.title
                annotation.subtitle = loc.description
                self.map.addAnnotation(annotation)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.map.showsUserLocation = true
    }
}

struct Location {
    let description: String;
    let hasAntennas: Bool;
    let hasLines: Bool;
    let hasNet: Bool;
    let lat: Double;
    let lng: Double;
    let numCourts: Int;
    let title: String;
    
    init(with dictionary: [String: Any]) {
        description = dictionary["description"] as! String
        hasAntennas = dictionary["hasAntennas"] as! Bool
        hasLines = dictionary["hasLines"] as! Bool
        hasNet = dictionary["hasNet"] as! Bool
        let nslat = dictionary["lat"] as! NSNumber
        lat = nslat.doubleValue
        let nslng = dictionary["lng"] as! NSNumber
        lng = nslng.doubleValue
        numCourts = dictionary["numCourts"] as! Int
        title = dictionary["title"] as! String
    }
}
