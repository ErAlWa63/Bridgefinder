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
    
    static let  sharedInstance = DataSource()
    var         delegateListView: DataSourceListViewDelegate? = nil
    var         delegateMapView:  DataSourceMapViewDelegate? = nil
    private var locationManager:  CLLocationManager? = nil
    private var nearestDistance:  Double? = nil
    private var bridgesReady  = false
    private var locationReady = false
    
    private var bridges: [BridgeObject] = [] {
        didSet {
            bridgesReady = true
            delegateListView?.bridgesDidChange()
            delegateMapView?.locationDidChange()
            calculateDistances()
        }
    }
    private var bridgesImages : Dictionary<String,ImageObject> = [:] {
        didSet {
            delegateListView?.bridgesDidChange()
            delegateMapView?.locationDidChange()
        }
    }
    
    private func calculateDistances () -> () {
        if self.bridgesReady && self.locationReady {
            for bridge in self.bridges {
                if self.bridgesReady {
                    bridge.distance = (self.locationManager?.location?.distance(
                        from: CLLocation(
                            latitude: bridge.latitude,
                            longitude: bridge.longitude)))! / 1000
                    if self.nearestDistance == nil {
                        self.nearestDistance = bridge.distance
                    } else {
                        if self.nearestDistance! > (bridge.distance)! {
                            self.nearestDistance = bridge.distance
                        }
                    }
                }
            }
//            let bridges = self.bridges
//            let sortedBridges = bridges.sorted(by: { $0.distance! > $1.distance! })
//            self.bridges = sortedBridges
            delegateListView?.bridgesDidChange()
        }
    }
    
    private func configLocationManager () -> () {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager = CLLocationManager()
            locationManager?.requestWhenInUseAuthorization()
        }
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 500
        locationManager?.startUpdatingLocation()
    }
    
    func countBridge () -> Int {
        return bridges.count
    }
    
    func getBridge (index: Int) -> BridgeObject {
        return bridges[index]
    }
    
    func getLocation () -> CLLocation? {
        return locationManager?.location
    }
    
    func getNearestDistanceBridge () -> Double? {
        return nearestDistance
    }
    
    func removeBridge (bridge: BridgeObject) -> () {
        d.c(s: "DataSource - removeBridge - start")
        FIRStorage.storage().reference().child(bridge.image).delete(completion: nil)
        d.c(s: "DataSource - removeBridge - storage")
        bridge.ref?.removeValue()
        d.c(s: "DataSource - removeBridge - database")
        
    }
    
    func loadBridges () -> () {
        configLocationManager()
        FIRDatabase.database().reference().observe(.value, with: { currentFIRDataSnapshot in
            self.bridgesReady = true
            var newBridgeObject: [BridgeObject] = []
            for currentChildAnyObject in currentFIRDataSnapshot.children {
                let currentBridgeObject = BridgeObject(snapshot: currentChildAnyObject as! FIRDataSnapshot)
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
        locationManager?.requestLocation()
    }
    
    func getImageObject (name: String) -> ImageObject? {
        if let bridgeImages = bridgesImages[name] {
            return bridgeImages
        } else {
            return nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            locationManager?.stopUpdatingLocation()
            locationReady = true
            delegateListView?.bridgesDidChange()
            delegateMapView?.locationDidChange()
            calculateDistances()
        }
    }
}
