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
        
        // Do any additional setup after loading the view.
    
        welcomeViewLabel.text = "Welcome"
        welcomeTextLabel.text = "Bridges is an app to find interesting bridges in you direct neighbourhood"
        explanationTextLabel.text = "Explanation: try this"
        welcomeImage.image = UIImage(named: "erasmusWelcome.png")
        
        
        
    
    }
    
    @IBOutlet var welcomeViewLabel: UILabel!

    @IBOutlet var welcomeTextLabel: UILabel!
    
    @IBOutlet var explanationTextLabel: UILabel!

    @IBOutlet var welcomeImage: UIImageView!
    
}