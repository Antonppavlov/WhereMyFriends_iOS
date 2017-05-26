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

class WelcomController: UIViewController {
    
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    
    let storage = LoginStorage()
    
//    public var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let login = storage.fetchLogin(), let phone = storage.fetchPhone() {
        labelLogin.text = login
        labelPhone.text = phone
        }
//        self.map.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
}

extension WelcomController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(userLocation.location ?? "qwe")
    }
}
