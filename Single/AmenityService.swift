//
//  AmenityService.swift
//  Single
//
//  Created by Etienne Vautherin on 04/04/2018.
//  Copyright © 2018 Alltouches. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import RxSwift

class AmenityService {

    static var shared = AmenityService()

    func amenities(coordinate: CLLocationCoordinate2D) -> Observable<[Amenity]> {
        return Observable.create({ observer in
            
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
                        if  let data = response.data,
                            let amenities = try? JSONDecoder().decode([Amenity].self, from: data) {
                            
                            observer.onNext(amenities)
                        } else {
                            observer.onNext([])
                        }
                        
                    case .failure(let error):
                        print("HTTP Request failed: \(error.localizedDescription)")
                        observer.onError(error)
                    }
            }

            return Disposables.create()
        })
    }
    
}
