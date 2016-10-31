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

class ListViewController: UITableViewController, AddViewControllerDelegate, DetailViewControllerDelegate {
    

    
    
    var bridge = BridgeObject(name: "A", description: "B", image: "leeg.png", latitude: 0.0, longitude: 0.0)
    
    func didSelectBridgeObject (controller: UITableViewController, bridge: BridgeObject) {
        if controller.navigationController?.popViewController(animated: true) == nil {return}
    }
    func didDetailView( controller: UITableViewController, bridge: BridgeObject) {
        if controller.navigationController?.popViewController(animated: true) == nil {return}
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bridge: BridgeObject? = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.currentBridge = DataSource.sharedInstance.getBridge(index: row)
//                detailViewController.delegate
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! BridgeObjectCellTableViewCell
        DispatchQueue.global(qos: .userInitiated).async {
            let bridge = DataSource.sharedInstance.getBridge(index: indexPath.row)
            FIRStorage.storage().reference().child(bridge.image).data(withMaxSize: 20*1024*1024, completion: { (data, error) -> Void in
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
            let bridge = DataSource.sharedInstance.getBridge(index: indexPath.row)
            FIRStorage.storage().reference().child(bridge.image).delete(completion: nil)
            bridge.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.sharedInstance.countBridge()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.rowHeight = 100
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.reloadData()
        
     }
    
    //    nog te testen:
    @IBAction func unwindListView(segue: UIStoryboardSegue) {
        print("Bridges: unwindListView")
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

