//
//  DetailViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    var delegate: AddViewControllerDelegate! = nil

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var bridgeImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
//    delegate.didSelectBridgeObject(controller: self as UITableViewController, bridge: BridgeObjectCalculated!)

    
    var currentBridge : BridgeObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        spinner.startAnimating()
        FIRStorage.storage().reference().child(currentBridge.image).data(withMaxSize: 20*1024*1024, completion: { (data, error) -> Void in
            DispatchQueue.main.async {
                if let downloadedData = data {
                    self.spinner.stopAnimating()
                    
                    self.nameLabel.text = self.currentBridge.name
                    self.descriptionLabel.text = self.currentBridge.description
                    self.locationLabel.text = "\(self.currentBridge.latitude) - \(self.currentBridge.longitude)"
                    self.bridgeImage.image = UIImage(data: downloadedData)!
                    self.title = self.currentBridge.name
                }
            }
        })
    }
}
