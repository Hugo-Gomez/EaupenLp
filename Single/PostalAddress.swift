//
//  PostalAddress.swift
//  Eaupen
//
//  Created by Etienne Vautherin on 13/02/2018.
//  Copyright © 2018 Alltouches. All rights reserved.
//

import UIKit

class PostalAddress: Decodable {
    var address: String?
    var postcode: String?
    var city: String?
    
    var description: String {
        return "\(address ?? "") - \(postcode ?? "") - \(city ?? "")"
    }
}
