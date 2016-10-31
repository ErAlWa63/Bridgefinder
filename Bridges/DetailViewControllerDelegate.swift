//
//  DetailViewControllerDelegate.swift
//  Bridges
//
//  Created by Erik Waterham on 29/10/2016.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate {
    func didDetailView( controller: UITableViewController, bridge: BridgeObject)
}
