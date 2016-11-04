//
//  DetailViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
        
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var nameLabel       : UILabel!
    @IBOutlet var locationLabel   : UILabel!
//    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var bridgeImage     : UIImageView!
    
    var currentBridge             : BridgeObject!
    var locationManager           : CLLocationManager!
    let regionRadius              : CLLocationDistance = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title                 = currentBridge.name
//        nameLabel.text        = currentBridge.name
//        descriptionLabel.text = currentBridge.descript
        descriptionTextView.text = currentBridge.descript
        bridgeImage.image     = DataSource.sharedInstance.getImageObject(name: currentBridge.image)?.photo
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        

        mapView.delegate = self
        
        mapView.mapType = MKMapType.standard
        let bridgeLocation = CLLocationCoordinate2D(latitude: currentBridge.latitude,longitude: currentBridge.longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let regionOne = MKCoordinateRegion(center: bridgeLocation, span: span)
        mapView.setRegion(regionOne, animated: true)
        
        let bridgeAnnotation = MKPointAnnotation()
        bridgeAnnotation.coordinate = bridgeLocation
        bridgeAnnotation.title = currentBridge.name
        mapView.addAnnotation(bridgeAnnotation)

        
        
        // Text settings
        
//        nameLabel.font = UIFont(name: "Futura", size: 25)
//        descriptionLabel.font = UIFont(name: "Futura", size: 17)
        distanceLabel.font = UIFont(name: "Futura", size: 26)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let bridgeLocation = CLLocation(latitude: currentBridge.latitude,longitude: currentBridge.longitude)
        
        let distanceInMeters = location.distance(from: bridgeLocation)
        
        let distanceInKilometers = distanceInMeters / 1000
        distanceLabel.text = String(format: "%.2f KM", distanceInKilometers)
        
        _ = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
}
}
