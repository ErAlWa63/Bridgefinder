//
//  TableViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ListViewController: UITableViewController {
    var items: [BridgeObject] = []
 
    @IBAction func unwindToMenuWithSegueListViewWithSegue(segue: UIStoryboardSegue) {
        print("Bridges: unwindToMenuWithSegueListViewWithSegue")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = items[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.currentBridge = item
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! BridgeObjectCellTableViewCell
        DispatchQueue.global(qos: .userInitiated).async {
            let bridge = self.items[indexPath.row]
            FIRStorage.storage().reference().child("photos").child(bridge.image).data(withMaxSize: 10*1024*1024, completion: { (data, error) -> Void in
                DispatchQueue.main.async {
                    if let downloadedData = data {
                        cell.nameCell?.text = bridge.name
                        cell.descriptionCell?.text = bridge.description
                        cell.locationCell?.text = "\(bridge.latitude) - \(bridge.longitude)"
                        cell.imageCell.image = UIImage(data: downloadedData)!
                    }
                }
            })
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bridge = items[indexPath.row]
            FIRStorage.storage().reference().child("photos").child(bridge.image).delete(completion: nil)
            bridge.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1
        //        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        //2
        //        var bridge = items[indexPath.row]
        //        performSegue(withIdentifier: "ShowItem", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.items = newBridgeObject
                self.tableView.reloadData()
            }
        })
        tableView.rowHeight = 100
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    
    
    // Segue Function
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //        print("Preparing")
    //        if (segue.identifier == "showSearchResult")
    //        {
    //            if let destinationViewController = segue.destinationViewController as? DetailViewController {
    //                destinationViewController.nam = self.moviePlot
    //                destinationViewController.imdbRating = self.movieRating
    //                destinationViewController.name = self.movieName
    //                destinationViewController.imagePath = self.moviePicturePath
    //
    //            }
    //        }
    //
    //    }
}

