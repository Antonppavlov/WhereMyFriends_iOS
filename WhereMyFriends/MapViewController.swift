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
    @IBOutlet weak var map: MKMapView! {
        didSet {
            map?.delegate        = self
            map?.mapType         = .standard
            map?.isPitchEnabled  = false
            map?.isRotateEnabled = false
            map?.isScrollEnabled = true
            map?.isZoomEnabled   = true
        }
    }
    
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var annotationView = self.map?.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = CUAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }
        else { annotationView?.annotation = annotation }
        annotationView?.image = #imageLiteral(resourceName: "1001511")
        return annotationView
    }
    //
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation { return }
        let detailAnnotation = view.annotation as! MKPointAnnotation
        let views = Bundle.main.loadNibNamed("CUDetailCamView", owner: nil, options: nil)
        let detailtView = views?[0] as! CUDetailCamView
        detailtView.address?.text = detailAnnotation.title
        detailtView.number = detailAnnotation.subtitle
//        detailtView.client = detailAnnotation.client
        let button = UIButton(frame: detailtView.address!.frame)
//        button.addTarget(self, action: #selector(MapViewController.showStream(sender:)), for: .touchUpInside)
        detailtView.addSubview(button)
        detailtView.center = CGPoint(x: view.bounds.size.width / 2, y: -detailtView.bounds.size.height * 0.52)
        view.addSubview(detailtView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: CUAnnotationView.self) {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
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
//          
//            let point = CUCamsAnnotation(latitude: person.latitude, longitude: person.longitude)
//
//            point.title  = person.name
//            point.subtitle = person.photo
          //  point.client  = false
            
            
            
            
            
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
