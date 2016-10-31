//
//  DataSource.swift
//  Bridges
//
//  Created by Erik Waterham on 26/10/2016.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class DataSource {
    static let sharedInstance = DataSource()
    private var bridges: [BridgeObject] = []
    
    func countBridge () -> Int {
        return bridges.count
    }
    
    func getBridge (index: Int) -> BridgeObject {
        return bridges[index]
    }
    
    func loadBridges () -> Void {
        FIRDatabase.database().reference().observe(.value, with: { currentFIRDataSnapshot in
            var newBridgeObject: [BridgeObject] = []
            for currentChildAnyObject in currentFIRDataSnapshot.children {
                let currentChildFIRDataSnapshot = currentChildAnyObject as! FIRDataSnapshot
                let BridgeObjectCalculated = BridgeObject(snapshot: currentChildFIRDataSnapshot)
                newBridgeObject.append(BridgeObjectCalculated)
            }
            self.bridges = newBridgeObject
        })
    }
    
//    func getBridgeAnnotations () -> NSObject {
//        var bridgeAnnotations = [BridgeAnnotation] ()
//        for bridge in bridges {
//            let currentBridgeAnnotation = BridgeAnnotation( coordinate: CLLocationCoordinate2DMake(bridge.latitude, bridge.longitude))
//            currentBridgeAnnotation.title = bridge.name
//            currentBridgeAnnotation.image = bridge.image
//            bridgeAnnotations.append( currentBridgeAnnotation)
//        }
//        return bridgeAnnotations as NSObject
//    }
}
