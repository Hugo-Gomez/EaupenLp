//
//  Amenity.swift
//  Eaupen
//
//  Created by Etienne Vautherin on 13/02/2018.
//  Copyright © 2018 Alltouches. All rights reserved.
//

import UIKit

class Amenity: Decodable {
    var _id: String?
    var source: String?
    var licence: String?
    var name: String?
    var amenity: String?
    var updated: Int?
    var point_type: String?
    var loc: Location?
    var postal_address: PostalAddress?
    var dist: Double?
    
    var description: String {
        guard let lat = loc?.lat, let lon = loc?.lon else { return "No location" }
        
        return "lat: \(lat), lon: \(lon)"
    }
    
    var displayName: String {
        guard let address = postal_address?.address else { return "" }
        
        return address
    }
}


