//
//  Location.swift
//  ET
//
//  Created by njoool  on 18/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import Foundation
import MapKit

class Locatioin: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return title
    }
}
