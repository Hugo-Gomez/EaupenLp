//
//  Annotation.swift
//  Eaupen
//
//  Created by Etienne Vautherin on 14/02/2018.
//  Copyright © 2018 Alltouches. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    let amenity: Amenity
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init?(amenity: Amenity) {
        guard let loc = amenity.loc, let lat = loc.lat, let lon = loc.lon else {
            return nil
        }
        
        self.amenity = amenity
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.title = amenity.displayName
        super.init()
    }
    
}
