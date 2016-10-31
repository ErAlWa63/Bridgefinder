//
//  DataSource.swift
//  Bridges
//
//  Created by Erik Waterham on 26/10/2016.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
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
            //            print("Bridges: currentFIRDataSnapshot = \(currentFIRDataSnapshot)")
            //            print("Bridges: currentFIRDataSnapshot.childrenCount = \(currentFIRDataSnapshot.childrenCount)")
                var newBridgeObject: [BridgeObject] = []
                for currentChildAnyObject in currentFIRDataSnapshot.children {
                    let currentChildFIRDataSnapshot = currentChildAnyObject as! FIRDataSnapshot
                    let BridgeObjectCalculated = BridgeObject(snapshot: currentChildFIRDataSnapshot)
                    newBridgeObject.append(BridgeObjectCalculated)
                    //                    print("Bridges: currentChildFIRDataSnapshot = \(currentChildFIRDataSnapshot)")
                    //                    print("Bridges: currentChildFIRDataSnapshot.childrenCount = \(currentChildFIRDataSnapshot.childrenCount)")
                }
                self.bridges = newBridgeObject
        })
        
    }
}
