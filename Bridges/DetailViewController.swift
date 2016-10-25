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
    
    
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var bridgeImage: UIImageView!
    
//    var items: [BridgeObject] = []
//    var productsValue = [[String:String]]()
    var passedValue = [[String:String]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        nameLabel.text = passedValue.description
//        nameLabel.text = valueTopass = [String:String]
//        locationLabel.text = productsValue.description
//        descriptionLabel.text = productsValue.description
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var bridgeDescription: UITextView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
