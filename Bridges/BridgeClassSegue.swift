//
//  BridgeClassSegue.swift
//  Bridges
//
//  Created by Thijs Lucassen on 26-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

//import UIKit
//import Firebase
//
//class BridgeClassSegue: UIViewController {
//    
//    var bridgeArray = [Bridge]()
////    let
//
//    func loadBridges() {
//        print("Loading bridges now")
//        referenceFIRDatabase.observeEventType(.Value) { (snapshot: FIRDataSnapshot!) in
//            let json = JSON(snapshot.value)
//            var bridgeArr = [Bridge]()
//            print(json)
//            for (key, subJson) in json {
//                let name = key
//                let description = subJson["Description"].string!
//                let distance = subJson["Distance"].double!
//                let latitude = subJson["Latitude"].double!
//                let longitude = subJson["Longitude"].double!
//                let image = UIImage(data: "plaatje.jpg")
//                
////                let imagePath = subJson["Image"].string!
////                var image = UIImage()
////                if let url = NSURL(string: imagePath) {
////                    if let data = NSData(contentsOfURL: url) {
////                        image = UIImage(data: data)!
////                    }
////                }
//                let bridge = Bridge(name: name, description: description, image: image, distance: distance, latitude: latitude, longitude: longitude)
//                bridgeArr.append(movie!)
//            }
//            self.myArray = bridgeArr
//        }
//    }
//    
//    
//}
