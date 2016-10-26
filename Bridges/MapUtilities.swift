//
//  MapUtilities.swift
//  Bridges
//
//  Created by Thijs Lucassen on 25-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import MapKit

// MARK: Helper Extensions

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        setRegion(region, animated: true)
    }
}
