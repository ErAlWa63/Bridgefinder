//
//  WelcomeViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeTextLabel.text = "find interesting bridges in your neighbourhood. Visit them, add missing bridges and add or change pictures..."
        welcomeTextLabel.textAlignment = NSTextAlignment.center
        welcomeTextLabel.font = UIFont(name: "Futura", size: 16)
        
        tapTextLabel.text = "Tap to start"
        tapTextLabel.textAlignment = NSTextAlignment.center
        tapTextLabel.font = UIFont(name: "Futura", size: 25)
        
//        welcomeImage.image = UIImage(named: "bridgesPictures.png")
        
        bridgeLogo.image = UIImage(named: "bridges-logo-one-wave.png")
        
        
    }
    
    @IBOutlet var welcomeTextLabel: UILabel!

    @IBOutlet var tapTextLabel: UILabel!
//    @IBOutlet var welcomeImage: UIImageView!
    
    @IBOutlet var bridgeLogo: UIImageView!
}
