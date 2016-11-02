//
//  TableViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, DataSourceDelegate {
    
    func bridgesDidChange () {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                (segue.destination as! DetailViewController).currentBridge = DataSource.sharedInstance.getBridge(index: row)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bridge                 = DataSource.sharedInstance.getBridge(index: indexPath.row)
        let cell                   = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! BridgeObjectCellTableViewCell
        cell.nameCell?.text        = bridge.name
        cell.descriptionCell?.text = bridge.descript
        cell.locationCell?.text    = "\(bridge.latitude) - \(bridge.longitude)"
        cell.imageCell.image       = DataSource.sharedInstance.getImageObject(name: bridge.image)?.photo.resizedImageWithinRect(rectSize: CGSize(width: 150, height: 150))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataSource.sharedInstance.removeBridge(bridge: DataSource.sharedInstance.getBridge(index: indexPath.row))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.sharedInstance.countBridge()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataSource.sharedInstance.delegate             = self
        tableView.rowHeight                            = 100
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.reloadData()
    }
}

