//
//  TableViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UITableViewController {

    
    // MARK: Constants
    //    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var items: [BridgeObject] = []
    var valueTopass = [String:String]()
    //    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! BridgeObjectCellTableViewCell
        let BridgeObject = items[indexPath.row]
        
        cell.nameCell?.text = BridgeObject.name
        cell.descriptionCell?.text = BridgeObject.description
        cell.locationCell?.text = "\(BridgeObject.latitude) - \(BridgeObject.longitude)"
        //        cell.detailTextLabel?.text = BridgeObject.addedByUser
        
        //        toggleCellCheckbox(cell, isCompleted: BridgeObject.completed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("Bridges: Cell delete")
        if editingStyle == .delete {
            let BridgeObject = items[indexPath.row]
            BridgeObject.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        //2
        var BridgeObject = items[indexPath.row]
        //3
        //        let toggledCompletion = !BridgeObject.completed
        //4
        //        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        //5
        //        BridgeObject.ref?.updateChildValues(["completed" : toggledCompletion])
        performSegue(withIdentifier: "ShowItem", sender: self)
    }
    

    
    // Segue Function
    

    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let referenceFIRDatabase = FIRDatabase.database().reference()
        //        print("Bridges: -----------------------------------------------")
        //        print("Bridges: referenceFIRDatabase = \(referenceFIRDatabase)")
        
        referenceFIRDatabase.observe(.value, with: { currentFIRDataSnapshot in
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
        tableView.rowHeight = 200
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        //        userCountBarButtonItem = UIBarButtonItem(title: "1",
        //                                                 style: .plain,
        //                                                 target: self,
        //                                                 action: #selector(userCountButtonDidTouch))
        //        userCountBarButtonItem.tintColor = UIColor.white
        //        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        //        user = User(uid: "FakeId", email: "hungry@person.food")
    }
    
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    

    
    // MARK: Add Item
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Bridges",
                                      message: "Add a bridge",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        //1
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        
                                        //2
                                        //                                        let BridgeObjectCalculated = BridgeObject(name: text, addedByUser: self.user.email, completed: false)
                                        //
                                        //                                        //3
                                        //                                        let BridgeObjectRef = self.ref.child(text.lowercased())
                                        //
                                        //                                        //4
                                        //                                        BridgeObjectRef.setValue(BridgeObjectCalculated.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //    func userCountButtonDidTouch() {
    //        performSegue(withIdentifier: listToUsers, sender: nil)
    //    }
    
    
}

