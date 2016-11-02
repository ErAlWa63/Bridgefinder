//
//  MapViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//
//  https://www.google.nl/maps/place/Erasmusbrug/@51.909004,4.484934,17z/data=!3m1!4b1!4m5!3m4!1s0x47c43366a91d4f5b:0xf43b51dff4165c58!8m2!3d51.909004!4d4.4871227?hl=nl
//  http://sweettutos.com/2016/03/16/how-to-completely-customise-your-map-annotations-callout-views/

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    let regionRadius: CLLocationDistance = 1
    
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        guard let coordinate = mapView.userLocation.location?.coordinate else { return }
        mapView.setRegion( MKCoordinateRegionMakeWithDistance( coordinate, 1000, 1000), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            (segue.destination as! DetailViewController).currentBridge = mapView.selectedAnnotations[0] as! BridgeObject
        }
    }
    
    override func viewDidLoad() {
        guard let coordinate = mapView.userLocation.location?.coordinate else { return }
        mapView.setRegion(
            MKCoordinateRegionMakeWithDistance(
                coordinate,
                DataSource.sharedInstance.getNearestDistanceBridge(),
                DataSource.sharedInstance.getNearestDistanceBridge()),
            animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated)
        mapView.mapType = MKMapType.standard
        mapView.delegate = self
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        for index in 0 ... (DataSource.sharedInstance.countBridge() - 1) {
            mapView.addAnnotation(DataSource.sharedInstance.getBridge(index: index))
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view : MKPinAnnotationView
        guard let annotation = annotation as? BridgeObject else {return nil}
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKPinAnnotationView {
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            view.pinTintColor = UIColor.blue
            view.isEnabled = true
            let button = UIButton(type: .detailDisclosure)
            button.addTarget(self, action: #selector(tapDetailViewController), for: UIControlEvents.touchUpInside)
            view.rightCalloutAccessoryView = button
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -9, y: -2)
            view.animatesDrop = true
        }
        view.leftCalloutAccessoryView = UIImageView(image: DataSource.sharedInstance.getImageObject(name: annotation.image)?.pictogram)
        return view
    }
    
    func tapDetailViewController () {
        performSegue(withIdentifier: "ShowItem", sender: self)
    }
}

