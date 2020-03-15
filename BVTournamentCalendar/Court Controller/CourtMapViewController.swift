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
            let span: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 2, longitudeDelta: 2)
            let region: MKCoordinateRegion = MKCoordinateRegion.init(center: locations[0].coordinate, span: span)
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
            region = MKCoordinateRegion.init(center: location, span: MKCoordinateSpan.init(latitudeDelta: 10, longitudeDelta: 10))
            userLocationSet = true
        } else {
            let sweCenter = CLLocationCoordinate2DMake(CLLocationDegrees(60.492579), CLLocationDegrees(15.286471))
            region = MKCoordinateRegion.init(center: sweCenter, span: MKCoordinateSpan.init(latitudeDelta: 10, longitudeDelta: 10))
            userLocationSet = false
        }
        
        map.setRegion(region, animated: true)
        
        // get data
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("courts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let courtList = snapshot.value as? NSDictionary
            
            for (key, value) in courtList! {
                let loc = Location(with: value as! [String: Any])
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(loc.lat), CLLocationDegrees(loc.lng))
                annotation.title = loc.title
                
                if(loc.title == "Mölnlycke Stensjön") {
                    print(key)
                }
                var subtitle = ""
                if(loc.description.trimmingCharacters(
                    in: CharacterSet.whitespacesAndNewlines
                    ) != "") {
                    subtitle += "Info/Bokning: " + loc.description + "\n"
                }
                subtitle += "Planer: " + String(loc.numCourts)
                subtitle += "\nAntenner: " + self.toString(bool:loc.hasAntennas)
                subtitle += "\nLinjer: " + self.toString(bool:loc.hasLines)
                subtitle += "\nNät: " + self.toString(bool:loc.hasNet)
                annotation.subtitle = subtitle
                
                self.map.addAnnotation(annotation)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.map.showsUserLocation = true
    }
    
    func toString(bool: Bool) -> String {
        if(bool){ return "Ja"}
        return "Nej"
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        let identifier = annotation.title! as! String

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = UIImage(named: "net")
           // var btn = UIButton(type: .detailDisclosure)
           // btn.setImage(UIImage(named:"net"), for: .normal)
           // annotationView?.rightCalloutAccessoryView = btn
            
        } else {
        //    annotationView?.annotation = annotation
        }
        annotationView?.annotation = annotation
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = annotation.subtitle!
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        annotationView?.detailCalloutAccessoryView = subtitleLabel
        
        annotationView?.clusteringIdentifier = "court"
        // annotationView?.rightCalloutAccessoryView = nil
      
        return annotationView
    }
}
/*
class CourtAnnotationView: MKMarkerAnnotationView {
    
    static let ReuseID = "courtAnnotation"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "court"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.unicycleColor
        glyphImage = #imageLiteral(resourceName: "unicycle")
    }
}
 */



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
