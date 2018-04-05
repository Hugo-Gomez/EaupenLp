//
//  ViewController.swift
//  Single
//
//  Created by Etienne Vautherin on 15/02/2018.
//  Copyright © 2018 Alltouches. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let disposeBag = DisposeBag()
    let mapDidChange = PublishSubject<Bool>()
    
//    var amenities: [Amenity]?
    
//    var amenities: [Amenity]? {
//        didSet { DispatchQueue.main.async(execute: reloadAnnotations) }
//    }
    
    var defaultCoordinate: CLLocationCoordinate2D {
        let defaults = UserDefaults.standard
        let userLocationExists = defaults.bool(forKey: "userLocationExists")
        
        return userLocationExists ?
            CLLocationCoordinate2D(latitude: defaults.double(forKey: "latitude"),
                                   longitude: defaults.double(forKey: "longitude"))
            :
            CLLocationCoordinate2D(latitude: 48.831034, longitude: 2.355265)
    }

    func saveUserLocation(coordinate: CLLocationCoordinate2D) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "userLocationExists")
        defaults.set(coordinate.latitude, forKey: "latitude")
        defaults.set(coordinate.longitude, forKey: "longitude")
        defaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.mapView.delegate = self
//        self.setupCoordinate(coordinate: defaultCoordinate)
        
        mapDidChange
            .map({ _ in self.mapView.centerCoordinate })
            .flatMap(AmenityService.shared.amenities)
            .map({ $0.compactMap(Annotation.init) })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { annotations in
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            })
            .disposed(by: disposeBag)
        
        let userCoordinate = Locator.shared.locationSubject
            .map({ $0.coordinate })

        let initialCoordinate = Observable.of(defaultCoordinate)
        
        let coordinate = Observable.merge(initialCoordinate, userCoordinate)

        coordinate
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { coordinate in
                let camera = MKMapCamera(lookingAtCenter: coordinate, fromEyeCoordinate: coordinate, eyeAltitude: 2000.0)
                self.mapView.setCamera(camera, animated: false)
                self.saveUserLocation(coordinate: coordinate)
            })
            .disposed(by: disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func localizeAction(_ sender: Any) {
        Locator.shared.start()
    }
    
////    func locator(_ locator: Locator, didUpdateLocation location: CLLocation) {
////        print(location.debugDescription)
////        self.setupCoordinate(coordinate: location.coordinate)
////        self.saveUserLocation(coordinate: location.coordinate)
////    }
//
//    func setupCoordinate(coordinate: CLLocationCoordinate2D) {
////        self.setAmenities(coordinate: coordinate)
//        DispatchQueue.main.async(execute: {
//            let camera = MKMapCamera(lookingAtCenter: coordinate, fromEyeCoordinate: coordinate, eyeAltitude: 2000.0)
//            self.mapView.setCamera(camera, animated: false)
//       })
//
////        _ = AmenityService.shared.amenities(coordinate: coordinate)
////            .observeOn(MainScheduler.instance)
////            .take(1)
////            .subscribe(onNext: { amenities in
////                self.amenities = amenities
////                self.reloadAnnotations()
////            }, onError: { error in
////                print("Error: \(error.localizedDescription)")
////            })
//    }
//
//    func reloadAnnotations() {
//        mapView.removeAnnotations(mapView.annotations)
//        if let annotations = amenities?.compactMap(Annotation.init) {
//            mapView.addAnnotations(annotations)
//        }
//    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showAmenity", let amenity = sender as? Amenity else { return }
        
        let controller = segue.destination as! AmenityViewController
        controller.amenity = amenity
    }
    
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
            
        case is MKUserLocation:
            return nil
            
        case is Annotation:
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return view
            
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard
            control == view.rightCalloutAccessoryView,
            let annotation = view.annotation as? Annotation
        else { return }
        
        let amenity = annotation.amenity
        self.performSegue(withIdentifier: "showAmenity", sender: amenity)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapDidChange.onNext(animated)
    }
}

