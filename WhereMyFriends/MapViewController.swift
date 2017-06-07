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

class MapViewController: UIViewController {
    
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    let storage = LoginStorage()
    let rootRef = Database.database().reference()
    let locationManager = CLLocationManager()
    
    // didSwitchedGPS
    @IBAction func didSwitchedGPS(_ sender: UISwitch) {
        if sender.isOn{
            locationManager.startUpdatingLocation()
        }else{
            myDeleteFunction(childIWantToRemove: storage.fetchPhone()!)
            locationManager.stopUpdatingLocation()
        }
        map.showsUserLocation = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let login = storage.fetchLogin(), let phone = storage.fetchPhone() {
            labelLogin.text = login
            labelPhone.text = phone
        }
        
        locationManager.requestAlwaysAuthorization()
        loadDataFromFarabase()
    }
    
    
    
    func refreshMKAnnotationList(listPersone:[Persone]) {
        
        map.removeAnnotations(self.map.annotations)
        
        for person in listPersone{
            let objectMKAnnotation = MKPointAnnotation()
            objectMKAnnotation.title = person.name
            objectMKAnnotation.subtitle = person.phone
            objectMKAnnotation.coordinate = CLLocationCoordinate2D(latitude: person.latitude, longitude: person.longitude)
            
            
            map.addAnnotation(objectMKAnnotation)
        }
        
    }
    
    func loadDataFromFarabase() {
        
        let rootRef = Database.database().reference().child("user")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        rootRef.observe(DataEventType.value, with: { (snapshot) in
            var listPersone = [Persone]()
            
            for emploee in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                let people = Persone(snapshot: emploee)
                if people.phone! != self.storage.fetchPhone()!{
                    listPersone.append(people)
                }
            }
            self.refreshMKAnnotationList(listPersone: listPersone)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }) { (error) in
            print(error)
        }
        
    }
    
    
    // MARK: - Firebase Delete
    func myDeleteFunction(childIWantToRemove: String) {
        rootRef.child("user").child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let name = storage.fetchLogin()!
        let phone = storage.fetchPhone()!
        let photo = storage.fetchPhoto()!
        let dateString = formatDate(date: Date())
        let latitude = userLocation.location?.coordinate.latitude
        let longitude = userLocation.location?.coordinate.longitude
        
        let noLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 12000, 12000)
        map.setRegion(viewRegion, animated: true)
        
        let newEmployee:NSDictionary = ["name":name, "phone":phone,"photo":photo, "date": dateString, "latitude":latitude!, "longitude":longitude!]
        
        rootRef.child("user").child(phone).setValue(newEmployee)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
}
