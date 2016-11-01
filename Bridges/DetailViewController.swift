//
//  DetailViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var nameLabel       : UILabel!
    @IBOutlet var locationLabel   : UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var bridgeImage     : UIImageView!
    
    var currentBridge             : BridgeObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title                 = currentBridge.name
        nameLabel.text        = currentBridge.name
        descriptionLabel.text = currentBridge.descript
        locationLabel.text    = "\(currentBridge.latitude) - \(currentBridge.longitude)"
        bridgeImage.image     = DataSource.sharedInstance.getImageObject(name: currentBridge.image)?.photo
    }
}
