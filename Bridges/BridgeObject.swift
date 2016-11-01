//
//  BridgeObject.swift
//  Bridges
//
//  Created by Erik Waterham on 26/10/2016.
//  Copyright © 2016 TL. All rights reserved.
//
//  Base on: http://sweettutos.com/2016/01/21/swift-mapkit-tutorial-series-how-to-customize-the-map-annotations-callout-request-a-transit-eta-and-launch-the-transit-directions-to-your-destination/

import Foundation
import Firebase
import MapKit

class BridgeObject: NSObject, MKAnnotation {
    
    let name       : String
    let descript   : String
    let image      : String
    let latitude   : Double
    let longitude  : Double
    let ref        : FIRDatabaseReference?
    let key        : String

    let coordinate : CLLocationCoordinate2D
    let title      : String?
    let distance   : Double?
    let identifier : String
    
    init(name: String, descript: String, image: String, latitude: Double, longitude: Double, key: String = "") {
        self.key = key
        self.name = name
        self.descript = descript
        self.image = image
        self.latitude = longitude
        self.longitude = latitude
        self.ref = nil
        self.title = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.distance = 0
        self.identifier = "BridgePin"
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshot.key
        descript = snapshotValue["Description"] as! String
        image = snapshotValue["Image"] as! String
        latitude = snapshotValue["Latitude"] as! Double
        longitude = snapshotValue["Longitude"] as! Double
        key = snapshot.key
        ref = snapshot.ref
        title = name
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.distance = 0
        self.identifier = "BridgePin"
    }
    
    func toAnyObject() -> Any {
        return [
            "Name": name,
            "Description": descript,
            "Image": image,
            "Latitude": latitude,
            "Longitude": longitude
        ]
    }

}
