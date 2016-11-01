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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
//            if let row = tableView.indexPathForSelectedRow?.row {
//                let detailViewController = segue.destination as! DetailViewController
//                detailViewController.currentBridge = DataSource.sharedInstance.getBridge(index: row)
                //                detailViewController.delegate
//            }
        }
    }
//    https://www.google.nl/maps/place/Erasmusbrug/@51.909004,4.484934,17z/data=!3m1!4b1!4m5!3m4!1s0x47c43366a91d4f5b:0xf43b51dff4165c58!8m2!3d51.909004!4d4.4871227?hl=nl
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        mapView.zoomToUserLocation()
    }
    
    var locationManager: CLLocationManager!
    let regionRadius: CLLocationDistance = 1

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated)

        locationManager = CLLocationManager()
        locationManager.stopUpdatingLocation()
        locationManager.requestAlwaysAuthorization()

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            locationManager = nil
        }
        
        mapView.mapType = MKMapType.standard
        
        for index in 0 ... (DataSource.sharedInstance.countBridge() - 1) {
            mapView.addAnnotation(DataSource.sharedInstance.getBridge(index: index))
        }
        
        
//        let point = BridgeAnnotation(coordinate: <#T##CLLocationCoordinate2D#>)
//        let locationOne = CLLocationCoordinate2D(latitude: 52.3725,longitude: 4.9182)
//        
//        let span = MKCoordinateSpanMake(1.5, 1.5)
//        let regionOne = MKCoordinateRegion(center: locationOne, span: span)
//        mapView.setRegion(regionOne, animated: true)
//        
//        let annotationOne = MKPointAnnotation()
//        annotationOne.coordinate = locationOne
//        annotationOne.title = "Erasmusbrug"
//        //        annotationOne.subtitle = "Thijs"
//        mapView.addAnnotation(annotationOne)
//        
//        let locationTwo = CLLocationCoordinate2D(latitude: 51.3482,longitude: 5.5471)
//        let annotationTwo = MKPointAnnotation()
//        annotationTwo.coordinate = locationTwo
//        annotationTwo.title = "Tower Bridge"
//        //        annotationTwo.subtitle = "Thijs"
//        mapView.addAnnotation(annotationTwo)
//        
//        let locationThree = CLLocationCoordinate2D(latitude: 51.9315,longitude: 4.4660)
//        let annotationThree = MKPointAnnotation()
//        annotationThree.coordinate = locationThree
//        annotationThree.title = "Willemsbrug"
//        //        annotationThree.subtitle = "Thijs"
//        mapView.addAnnotation(annotationThree)
        
// http://sweettutos.com/2016/03/16/how-to-completely-customise-your-map-annotations-callout-views/
//        mapView.addAnnotation(DataSource.sharedInstance.getBridgeAnnotations() as! MKAnnotation)

    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
//        if !(annotation is BridgeObject){
//            return nil
//        }
//        
//        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
//        
//        if annotationView == nil{
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
//            annotationView?.canShowCallout = true
//        }else{
//            annotationView?.annotation = annotation
//        }
//        let bridgeAnnotation = annotation as! BridgeObject
//
//        FIRStorage.storage().reference().child(restaurantAnnotation.image).data(withMaxSize: 20*1024*1024, completion: { (data, error) -> Void in
//            DispatchQueue.main.async {
//                if let downloadedData = data {
//                    cell.imageCell.image = UIImage(data: downloadedData)!
//                    annotationView?.detailCalloutAccessoryView = UIImage(data: downloadedData)!
//                    
//                    // Left Accessory
//                    let leftAccessory = UILabel(frame: CGRectMake(0,0,50,30))
//                    leftAccessory.text = restaurantAnnotation.eta
//                    leftAccessory.font = UIFont(name: "Verdana", size: 10)
//                    annotationView?.leftCalloutAccessoryView = leftAccessory
//                    
//                    // Right accessory view
//                    let image = UIImage(named: "bus.png")
//                    let button = UIButton(type: .Custom)
//                    button.frame = CGRectMake(0, 0, 30, 30)
//                    button.setImage(image, forState: .Normal)
//                    annotationView?.rightCalloutAccessoryView = button
//                    return annotationView
//
//                }
//            }
//        })
//
//        
//    }
    
//    private func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        mapView.setRegion(region, animated: true)
//    }
    
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
