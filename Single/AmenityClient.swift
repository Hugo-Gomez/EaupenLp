//
//  AmenityClient.swift
//  Eaupen
//
//  Created by Etienne Vautherin on 13/02/2018.
//  Copyright © 2018 Alltouches. All rights reserved.
//

import CoreLocation
import Alamofire

protocol AmenityClient: class {
    var amenities: [Amenity]? { get set }
}


extension AmenityClient {
    
    func setAmenities(coordinate: CLLocationCoordinate2D) {
        /*
         Request
         get http://api.eaupen.net/closest
         */
        
        // Add Headers
        let headers = [
            "Accept":"application/json",
            ]
        
        // Add URL parameters
        let urlParams = [
            "lat": coordinate.latitude,
            "lon": coordinate.longitude,
            "limit": 50,
            "range": 1500.0,
            ]
        
        // Fetch Request
        Alamofire.request("http://api.eaupen.net/closest", method: .get, parameters: urlParams, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        self.amenities = try? JSONDecoder().decode([Amenity].self, from: data)
                        
                        if let amenities = self.amenities {
                            print(amenities.map({ $0.description }))
                        }
                    }
                    
                case .failure(let error):
                    print("HTTP Request failed: \(error.localizedDescription)")
                }
        }
    }
    
}


