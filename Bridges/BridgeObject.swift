//
//  FirebaseObject.swift
//  Bridges
//
//  Created by Erik Waterham on 26/10/2016.
//  Copyright © 2016 TL. All rights reserved.
//

import Foundation
import Firebase

struct BridgeObject {
    
    let name: String
    let description: String
    let image: String
    let latitude: Double
    let longitude: Double
    let ref: FIRDatabaseReference?
    let key: String
    
    init(name: String, description: String, image: String, latitude: Double, longitude: Double, key: String = "") {
        self.key = key
        self.name = name
        self.description = description
        self.image = image
        self.latitude = longitude
        self.longitude = latitude
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshot.key
        description = snapshotValue["Description"] as! String
        image = snapshotValue["Image"] as! String
        latitude = snapshotValue["Latitude"] as! Double
        longitude = snapshotValue["Longitude"] as! Double
        key = snapshot.key
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "Name": name,
            "Description": description,
            "Image": image,
            "Latitude": latitude,
            "Longitude": longitude
        ]
    }
    
}
