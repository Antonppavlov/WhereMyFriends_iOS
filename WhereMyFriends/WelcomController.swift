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
    
 
    let locationManager = CLLocationManager()
    
    let storage = LoginStorage()
    
 let rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let login = storage.fetchLogin(), let phone = storage.fetchPhone() {
        labelLogin.text = login
        labelPhone.text = phone
        }
 
        locationManager.requestAlwaysAuthorization()
    }
}

extension WelcomController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        rootRef.childByAutoId().setValue(userLocation.location?.coordinate.latitude.binade)
        rootRef.childByAutoId().setValue(userLocation.location?.coordinate.longitude.binade)
//        print(userLocation.location?.coordinate.latitude.binade ?? "qwe")
    }
}
