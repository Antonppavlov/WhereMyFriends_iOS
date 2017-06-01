//
//  WelcomController.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 25.05.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//
import UIKit
import Foundation
import MapKit
import Firebase

class WelcomController: UIViewController {
    
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    // didSwitchedGPS
    @IBAction func didSwitchedGPS(_ sender: UISwitch) {
        sender.isOn
            ?
            locationManager.startUpdatingLocation()
            :
            locationManager.stopUpdatingLocation()
        
      map.showsUserLocation = sender.isOn

    }
 
    // MARK: - Methods
    let locationManager = CLLocationManager()
    
    let storage = LoginStorage()
    var annotationsArray: [MKAnnotation] {
        let coordinatesArray = getLocation()
        return coordinatesArray.map { location in
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Имя"
            annotation.subtitle = "телефон"
            return annotation
        }
    }
    
 let rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let login = storage.fetchLogin(), let phone = storage.fetchPhone() {
        labelLogin.text = login
        labelPhone.text = phone
        }
 
        locationManager.requestAlwaysAuthorization()
        
        map.addAnnotations(annotationsArray)
    }
    
    func getLocation() -> [CLLocationCoordinate2D] {
        
        var arr = [CLLocationCoordinate2D]()
        
        let obj1 = CLLocationCoordinate2D(latitude: 55.6593521,longitude: 37.625195)
        let obj2 = CLLocationCoordinate2D(latitude: 55.9593521,longitude: 37.425195)
        let obj3 = CLLocationCoordinate2D(latitude: 55.4593521,longitude: 37.325195)

        arr.append(obj1)
        arr.append(obj2)
        arr.append(obj3)
        
        return arr;
    }
}



extension WelcomController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        rootRef.childByAutoId().setValue(userLocation.location?.coordinate.latitude.binade)
        rootRef.childByAutoId().setValue(userLocation.location?.coordinate.longitude.binade)
//        print(userLocation.location?.coordinate.latitude.binade ?? "qwe")
    }
    
//  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?   {
//        return MKAnnotationView()
//    }
}
