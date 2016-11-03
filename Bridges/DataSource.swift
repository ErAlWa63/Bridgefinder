//
//  DataSource.swift
//  Bridges
//
//  Created by Erik Waterham on 26/10/2016.
//  Copyright © 2016 TL. All rights reserved.
//
//  https://makeapppie.com/2016/08/01/using-observers-and-delegates-on-the-model/

import Firebase
import CoreLocation

protocol DataSourceListViewDelegate{
    func bridgesDidChange()
}

protocol DataSourceMapViewDelegate {
    func locationDidChange()
}

class DataSource: NSObject, CLLocationManagerDelegate {
    let d = D() // debugger functionality
    
    static let sharedInstance = DataSource()
    var delegateListView: DataSourceListViewDelegate? = nil
    var delegateMapView: DataSourceMapViewDelegate? = nil
    private var locationManager: CLLocationManager!
    private var nearestDistance: Double!
    
    private var bridges: [BridgeObject] = [] {
        didSet {
            delegateListView?.bridgesDidChange()
        }
    }
    private var bridgesImages : Dictionary<String,ImageObject> = [:] {
        didSet {
            delegateListView?.bridgesDidChange()
        }
    }
    
    private func configLocationManager () -> () {
        d.c(s: "DataSource - configLocationManager - start")
        
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 500
//        locationManager.allowsBackgroundLocationUpdates = true
        d.c(s: "DataSource - configLocationManager - step 1")
        
        locationManager.startUpdatingLocation()
        d.c(s: "DataSource - configLocationManager - step 2")
        
//        locationManager.requestLocation()
        d.c(s: "DataSource - configLocationManager - step 3")
        
//        locationManager.stopUpdatingLocation()
        d.c(s: "DataSource - configLocationManager - step 4")
        
        if locationManager.location == nil {
            d.c(s: "DataSource - configLocationManager - locationManager.location == nil")
        } else {
            d.c(s: "DataSource - configLocationManager - locationManager.location = \(locationManager.location)")
        }
        d.c(s: "DataSource - configLocationManager - end")
        
    }
    
    func countBridge () -> Int {
        return bridges.count
    }
    
    func getBridge (index: Int) -> BridgeObject {
        return bridges[index]
    }
    
    func getLocation () -> CLLocation {
        return locationManager.location!
    }
    
    func getNearestDistanceBridge () -> Double {
        return nearestDistance
    }
    
    func removeBridge (bridge: BridgeObject) -> () {
        FIRStorage.storage().reference().child(bridge.image).delete(completion: nil)
        bridge.ref?.removeValue()
    }
    
    func loadBridges () -> () {
        configLocationManager()
        FIRDatabase.database().reference().observe(.value, with: { currentFIRDataSnapshot in
            var newBridgeObject: [BridgeObject] = []
            for currentChildAnyObject in currentFIRDataSnapshot.children {
                let currentBridgeObject = BridgeObject(snapshot: currentChildAnyObject as! FIRDataSnapshot)
                currentBridgeObject.distance = 0
                //                    (self.locationManager.location?.distance(
                //                        from: CLLocation(
                //                            latitude: currentBridgeObject.latitude,
                //                            longitude: currentBridgeObject.longitude)))! / 1000
                currentBridgeObject.descript += String(format: "(%.3f km)", currentBridgeObject.distance!)
                if self.nearestDistance == nil {
                    self.nearestDistance = currentBridgeObject.distance
                }
                if let selfNearestDistance = self.nearestDistance {
                    if selfNearestDistance > (currentBridgeObject.distance)! {
                        self.nearestDistance = currentBridgeObject.distance
                    }
                }
                self.loadImageObject(name: currentBridgeObject.image)
                newBridgeObject.append(currentBridgeObject)
            }
            self.bridges = newBridgeObject
        })
    }
    
    func loadImageObject (name: String) -> () {
        if bridgesImages[name] == nil {
            DispatchQueue.global(qos: .userInitiated).async {
                FIRStorage.storage().reference().child(name).data(withMaxSize: 20*1024*1024, completion: { (data, error) -> Void in
                    if let downloadedData = data {
                        self.bridgesImages[name] = ImageObject( photo: UIImage(data: downloadedData)!)
                    }
                })
            }
        }
    }
    
    func loadCurrentLocalization () -> () {
                locationManager.requestLocation()
    }
    
    func getImageObject (name: String) -> ImageObject? {
        if let bridgeImages = bridgesImages[name] {
            return bridgeImages
        } else {
            return nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        d.c(s: "DataSource - locationManager - locations = \(locations)")

        if let location = locations.last {
            d.c(s: "DataSource - locationManager - Found user's location: \(location)")
            locationManager.stopUpdatingLocation()
            delegateMapView?.locationDidChange()

        }
    }
}
