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
import PhoneNumberKit

class MapViewController: UIViewController {
    
   
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
        if annotationView == nil {
          
         //   let detailAnnotation = annotation as! CUCamsAnnotation
           
            annotationView = CUAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
       
          let pinImage = UIImage(named: "location")!
         //  let pinImage = detailAnnotation.image!
 
            let del = pinImage.size.width/40
            
            let size = CGSize(width: pinImage.size.width/del, height: pinImage.size.height/del)
            UIGraphicsBeginImageContext(size)
            pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            annotationView?.centerOffset = CGPoint(x: 0, y: -size.height/2)
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = resizedImage
            
            let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
            annotationView?.rightCalloutAccessoryView = rightButton as? UIView

        }
        else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.map.removeOverlays(mapView.overlays)
        
        if view.annotation is MKUserLocation { return }
    
//        let dummyLabel = UILabel()
//        dummyLabel.text = "Abra_Kadabra"
//        let size = dummyLabel.sizeattr
//        
        
        
        let detailAnnotation = view.annotation as! CUCamsAnnotation
        
        self.route(firstCoordinate: CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!), secondCoordinate: detailAnnotation.coordinate)
        let detailtView = CUDetailCamView(frame: CGRect(x: 0, y: 0, width: 130, height: 40))
        
        detailtView.address?.text = detailAnnotation.title
        detailtView.labelDate?.text = detailAnnotation.subtitle
        //detailtView.labelDate?.text = distance
        detailtView.image?.image = detailAnnotation.image!
 
        let button = UIButton(frame: detailtView.address!.frame)
//        button.addTarget(self, action: #selector(MapViewController.showStream(sender:)), for: .touchUpInside)
        detailtView.addSubview(button)
        detailtView.center = CGPoint(x: view.bounds.size.width / 2, y: -detailtView.bounds.size.height * 0.52)
        view.addSubview(detailtView)
        

        
        
        //mapView.setCenter((view.annotation?.coordinate)!, animated: true)
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
        
        if let phone = storage.fetchPhone() {
      
            labelPhone.text = phone
        }
        
        locationManager.requestAlwaysAuthorization()
        loadDataFromFarabase()
    }
    
    
    
    func refreshMKAnnotationList(listPersone:[Persone]) {
        
        map.removeAnnotations(self.map.annotations)
        
        for person in listPersone{
            let objectMKAnnotation = CUCamsAnnotation()
            objectMKAnnotation.title = person.name
            objectMKAnnotation.subtitle = person.phone
            objectMKAnnotation.coordinate = CLLocationCoordinate2D(latitude: person.latitude, longitude: person.longitude)
            objectMKAnnotation.image = populateImage(imageString: person.photo)
            
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

    
    
    
    
    
    //отрисовка маршрута
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3.5
        
        renderer.strokeColor = UIColor(red: 0, green: 165/255, blue: 1, alpha: 1)
        return renderer
    }
    
    
    func route(firstCoordinate: CLLocationCoordinate2D, secondCoordinate: CLLocationCoordinate2D){


        
        let firstItem = MKMapItem(placemark: MKPlacemark(coordinate: firstCoordinate))
        let secondItem = MKMapItem(placemark: MKPlacemark(coordinate: secondCoordinate))
        
        let request = MKDirectionsRequest()
        request.source = firstItem
        request.destination  = secondItem
        
        request.transportType  = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else{
                NSLog("Eror of requesting: \(error.debugDescription)")
                return
            }
            if response.routes.count>0{
                let route = response.routes.first!
                self.map.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                let rect = route.polyline.boundingMapRect
//                self.map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                
            }
            
        }
    }

    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
}


extension MapViewController: MKMapViewDelegate {
    
   
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let phoneNumberKit = PhoneNumberKit()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let name = storage.fetchLogin()!
        let phone = storage.fetchPhone()!
        let photo = storage.fetchPhoto()!
        let dateString = formatDate(date: Date())
         self.latitude = userLocation.location?.coordinate.latitude
         self.longitude = userLocation.location?.coordinate.longitude
        
        let noLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 12000, 12000)
        map.setRegion(viewRegion, animated: true)
        
        let newEmployee:NSDictionary = ["name":name, "phone":phone,"photo":photo, "date": dateString, "latitude":latitude!, "longitude":longitude!]
        
        rootRef.child("user").child(phone).setValue(newEmployee)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
}
