//
//  MapViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
//            if let row = tableView.indexPathForSelectedRow?.row {
//                let detailViewController = segue.destination as! DetailViewController
//                detailViewController.currentBridge = DataSource.sharedInstance.getBridge(index: row)
                //                detailViewController.delegate
//            }
        }
    }
    

    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        mapView.zoomToUserLocation()
    }
    
    var locationManager: CLLocationManager!
    let regionRadius: CLLocationDistance = 1
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.stopUpdatingLocation()
            
        }
        
        
        mapView.mapType = MKMapType.standard
        let locationOne = CLLocationCoordinate2D(latitude: 52.3725,longitude: 4.9182)
        
        let span = MKCoordinateSpanMake(1.5, 1.5)
        let regionOne = MKCoordinateRegion(center: locationOne, span: span)
        mapView.setRegion(regionOne, animated: true)
        
        let annotationOne = MKPointAnnotation()
        annotationOne.coordinate = locationOne
        annotationOne.title = "Erasmusbrug"
        //        annotationOne.subtitle = "Thijs"
        mapView.addAnnotation(annotationOne)
        
        let locationTwo = CLLocationCoordinate2D(latitude: 51.3482,longitude: 5.5471)
        let annotationTwo = MKPointAnnotation()
        annotationTwo.coordinate = locationTwo
        annotationTwo.title = "Tower Bridge"
        //        annotationTwo.subtitle = "Thijs"
        mapView.addAnnotation(annotationTwo)
        
        let locationThree = CLLocationCoordinate2D(latitude: 51.9315,longitude: 4.4660)
        let annotationThree = MKPointAnnotation()
        annotationThree.coordinate = locationThree
        annotationThree.title = "Willemsbrug"
        //        annotationThree.subtitle = "Thijs"
        mapView.addAnnotation(annotationThree)

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func zoomInOnLocation() {
        let userLocation = MKUserLocation()
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        let currentLocation: CLLocation? = userLocation.location
        let latitude = currentLocation?.coordinate.latitude
        let longitude = currentLocation?.coordinate.longitude
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let coordinatRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinatRegion, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
