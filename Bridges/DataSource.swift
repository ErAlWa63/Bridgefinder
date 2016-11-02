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
//    private var currentLocation : CLLocation()
    
    func countBridge () -> Int {
        return bridges.count
    }
    
    func getBridge (index: Int) -> BridgeObject {
        return bridges[index]
    }
    
    func removeBridge (bridge: BridgeObject) -> () {
        FIRStorage.storage().reference().child(bridge.image).delete(completion: nil)
        bridge.ref?.removeValue()
    }
    
    func loadBridges () -> () {
        FIRDatabase.database().reference().observe(.value, with: { currentFIRDataSnapshot in
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
    
    func getImageObject (name: String) -> ImageObject? {
        if let bridgeImages = bridgesImages[name] {
            return bridgeImages
        } else {
            return nil
        }
    }
    
}
