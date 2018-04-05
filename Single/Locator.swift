//
//  Locator.swift
//  Eaupen
//
//  Created by Etienne Vautherin on 14/02/2018.
//  Copyright © 2018 Alltouches. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class Locator: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
//    var delegate: LocatorDelegate?
    
    static var shared = Locator()
    
    let locationSubject = PublishSubject<CLLocation>()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .denied: break
        case .restricted: break
        case .authorizedWhenInUse: locate()
        case .authorizedAlways: break
        }
    }

//    func start(delegate: LocatorDelegate) {
//        self.delegate = delegate
//        switch CLLocationManager.authorizationStatus() {
//        case .notDetermined: manager.requestWhenInUseAuthorization()
//        case .denied: break
//        case .restricted: break
//        case .authorizedWhenInUse: locate()
//        case .authorizedAlways: break
//        }
//    }
    
    func locate() {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
        case .denied: break
        case .restricted: break
        case .authorizedWhenInUse: locate()
        case .authorizedAlways: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
//        if let location = locations.last, let delegate = self.delegate {
//            delegate.locator(self, didUpdateLocation: location)
//            locationSubject.onNext(location)
//        }
        if let location = locations.last {
            locationSubject.onNext(location)
        }
    }
}


//protocol LocatorDelegate {
//    func locator(_ locator: Locator, didUpdateLocation location: CLLocation)
//}
