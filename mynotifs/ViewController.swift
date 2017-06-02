//
//  ViewController.swift
//  b
//
//  Created by surendra kumar on 2/18/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    var geoFire : GeoFire!
    var geoFireRef : FIRDatabaseReference!
    @IBOutlet var mapViewStory: MKMapView!
    var launched = false
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        if let location = mapViewStory.userLocation.location{
            showSightingonMap(location: location)
        }
       mapViewStory.userTrackingMode = .follow
    }
    
    
    func requestLocation(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied,.restricted:
            print("location access denied")
        default:
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    func centerLocation(location : CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapViewStory.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location{
            if !launched{
                centerLocation(location: loc)
                launched = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        let annotationView : MKAnnotationView?
        if annotation is MKUserLocation{
            let annotatioView = mapView.dequeueReusableAnnotationView(withIdentifier: "User") ?? MKAnnotationView()
            annotatioView.image = UIImage(named: "ash")
           
            return annotatioView
        }else if let anno = mapViewStory.dequeueReusableAnnotationView(withIdentifier: "pokemon"){
            annotationView = anno
            annotationView?.annotation = annotation
        }else{
            let anno = MKAnnotationView(annotation: annotation, reuseIdentifier: "pokemon")
            annotationView = anno
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        
        if let annotationView = annotationView , let anno = annotation as? PokeAnnotation{
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named : "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        
        return annotationView
    }
    //save new pokemon
    func createSighting(forlocation : CLLocation,withPokemon pokeId: Int){
        geoFire.setLocation(forlocation, forKey: "\(pokeId)")
    }
    
    //show pokemon
    func showSightingonMap(location : CLLocation){
        let circleQuery = geoFire.query(at: location, withRadius: 0.5)
        
        circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            print("Reading................")
            if let key = key, let location = location{
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                print("the key is ........\(key)")
                self.mapViewStory.addAnnotation(anno)
            }
        })
    }
    
    // if user see any pokemon then save it
    @IBAction func showrandomPokemon(_ sender: Any) {
            let loc = CLLocation(latitude: mapViewStory.centerCoordinate.latitude, longitude: mapViewStory.centerCoordinate.longitude)
            let random  = arc4random_uniform(151) + 1
         createSighting(forlocation: loc, withPokemon: Int(random))
        showSightingonMap(location: loc)
    }
    
    
    @IBAction func currrentLocation(_ sender: Any) {
        
        centerLocation(location: mapViewStory.userLocation.location!)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("Region is changing.......")
        let location = CLLocation(latitude: mapViewStory.centerCoordinate.latitude, longitude: mapViewStory.centerCoordinate.longitude)
        print("location is : \(location.coordinate)")
        showSightingonMap(location: location)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("accesoryTapped")
//        if let anno = view.annotation as? PokeAnnotation{
//            let place = MKPlacemark(coordinate: anno.coordinate)
//            let destination = MKMapItem(placemark: place)
//            destination.name = "Pokemon Sighting"
//            let regiondistance : CLLocationDistance = 1000
//            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regiondistance, regiondistance)
//            let option  = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate : regionSpan.center),MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan : regionSpan.span),MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
//            MKMapItem.openMaps(with: [destination], launchOptions: option)
    //    }
        UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=Google+Inc,+8th+Avenue,+New+York,+NY&daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York&directionsmode=transit")!)
    }
}

