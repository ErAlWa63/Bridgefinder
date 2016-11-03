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

protocol DataSourceDelegate{
    func bridgesDidChange()
}

class DataSource {
    static let sharedInstance = DataSource()
    var delegate: DataSourceDelegate? = nil
    private var locationManager: CLLocationManager!
    private var nearestDistance: Double!
    
    private var bridges: [BridgeObject] = [] {
        didSet {
            delegate?.bridgesDidChange()
        }
    }
    private var bridgesImages : Dictionary<String,ImageObject> = [:] {
        didSet {
            delegate?.bridgesDidChange()
        }
    }
    
    private func configLocationManager () -> () {
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager.requestLocation()
        if locationManager.location == nil {
            print("Bridges: locationManager.location = nil")
        }
        print("Bridges: location loaded")
    }
    
    func countBridge () -> Int {
        return bridges.count
    }
    
    func getBridge (index: Int) -> BridgeObject {
        return bridges[index]
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
    
    func getImageObject (name: String) -> ImageObject? {
        if let bridgeImages = bridgesImages[name] {
            return bridgeImages
        } else {
            return nil
        }
    }
    
}
