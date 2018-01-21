//
//  Artwork.swift
//  AnalyzingScreen
//
//  Created by Ritik Batra on 1/20/18.
//  Copyright © 2018 Ritik Batra. All rights reserved.
//

import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}

