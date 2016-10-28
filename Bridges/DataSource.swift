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
            for currentChildAnyObject in currentFIRDataSnapshot.children {
                let currentChildFIRDataSnapshot = currentChildAnyObject as! FIRDataSnapshot
                //                print("Bridges: currentChildFIRDataSnapshot = \(currentChildFIRDataSnapshot)")
                //                print("Bridges: currentChildFIRDataSnapshot.childrenCount = \(currentChildFIRDataSnapshot.childrenCount)")
                var newBridgeObject: [BridgeObject] = []
                for currentChildChildAnyObject in currentChildFIRDataSnapshot.children {
                    let currentChildChildFIRDataSnapshot = currentChildChildAnyObject as! FIRDataSnapshot
                    let BridgeObjectCalculated = BridgeObject(snapshot: currentChildChildFIRDataSnapshot)
                    newBridgeObject.append(BridgeObjectCalculated)
                    //                    print("Bridges: currentChildChildFIRDataSnapshot = \(currentChildChildFIRDataSnapshot)")
                    //                    print("Bridges: currentChildChildFIRDataSnapshot.childrenCount = \(currentChildChildFIRDataSnapshot.childrenCount)")
                }
                self.bridges = newBridgeObject
            }
        })
        
    }
    func initFirebase () -> Void {
        FIRDatabase.database().reference().observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("Bridges"){
                print("Bridges exist")
            } else {
                print("Bridges doesn't exist")
                FIRDatabase.database().reference().setValue("Bridges")
//                FIRDatabase.database().reference().child("Bridges")
            }
        })
        
    }
    
    // items (totdat alles is omgezet naar bridges laten staan voor Erik
    
}
