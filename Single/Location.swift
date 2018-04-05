//
//  Location.swift
//  Eaupen
//
//  Created by Etienne Vautherin on 13/02/2018.
//  Copyright © 2018 Alltouches. All rights reserved.
//

import UIKit

class Location: Decodable {
    var lat: Double?
    var lon: Double?
    
    var description: String {
        guard let lat = lat, let lon = lon else { return "No location" }
        
        return "lat: \(lat), lon: \(lon)"
    }
}

