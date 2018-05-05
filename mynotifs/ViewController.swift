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

var colors = [UIColor]()
class ViewController: UIViewController{
    
   
    @IBOutlet var mapViewStory: MKMapView!
    @IBOutlet weak var userlocationbutton: UIButton!
    @IBOutlet weak var addbutton: UIButton!
    var times : Int = 20
    var launched = false
    let locationManager = CLLocationManager()
    var geoFire : GeoFire!
    var geoFireRef : DatabaseReference!
    var selectedPoke = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0..<pokemon.count{
            selectedPoke.append(index)
        }
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        if let location = mapViewStory.userLocation.location{
            showSightingonMap(location: location, filter: selectedPoke)
        }
       locationManager.delegate = self
        locationManager.requestLocation()
        mapViewStory.userTrackingMode = .follow
        mapViewStory.showsUserLocation = true
        
        userlocationbutton.ApplyShadow()
        addbutton.ApplyShadow()
        
        for _ in 0..<pokemon.count {
           colors.append(UIColor.random())
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //requestLocation()
    }
    
    // if user see any pokemon then save it
    @IBAction func showrandomPokemon(_ sender: Any) {
//            let loc = CLLocation(latitude: mapViewStory.centerCoordinate.latitude, longitude: mapViewStory.centerCoordinate.longitude)
//            let random  = arc4random_uniform(151) + 1
//         createSighting(forlocation: loc, withPokemon: Int(random))
//         showSightingonMap(location: loc)
        let vc = PokeListVC()
        vc.delegate = self
        vc.textLB = "Select pokemon to add"
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func filterButton(_ sender: Any) {
        let vc = PokeListVC()
        vc.delegate = self
        vc.textLB = "Select pokemon to show"
        vc.isAllowMultSelection = true
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func currrentLocation(_ sender: Any) {
        guard let location = mapViewStory.userLocation.location else {return}
        centerLocation(location: location)
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
    
    
    //save new pokemon
    func createSighting(forlocation : CLLocation,withPokemon pokeId: Int){
        geoFire.setLocation(forlocation, forKey: "\(pokeId)")
    }
    
    //show pokemon
    func showSightingonMap(location : CLLocation, filter: [Int]){
        let circleQuery = geoFire.query(at: location, withRadius: 0.5)
        circleQuery.observe(GFEventType.keyEntered, with: { (_key, location) in
            let key : Int = Int(_key)!
            if self.selectedPoke.contains(key){
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: key)
                self.mapViewStory.addAnnotation(anno)
            }
        })
    }
    
}

extension ViewController :  CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        showSightingonMap(location: locations.first!, filter: selectedPoke)
    }
}

extension ViewController : MKMapViewDelegate{
    
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
            annotatioView.image = UIImage(named: "user")
            annotatioView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            return nil
        }else{
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pokemon") ?? MKAnnotationView()
            let image = UIImage(named: "Marker")?.withRenderingMode(.alwaysTemplate)
            let anno  = annotation  as! PokeAnnotation
            print(anno.pokemonNumber)
            annotationView?.image = image?.imageWithColor(color1: colors[anno.pokemonNumber % (pokemon.count-1)])
            annotationView?.canShowCallout = true
            
//            if times > 0 {
//            annotationView?.layer.shadowColor = UIColor.black.cgColor
//            annotationView?.layer.shadowOpacity = 1.0
//            annotationView?.layer.shadowOffset = CGSize(width:1, height: 2)
//                annotationView?.layer.shouldRasterize = true
//                annotationView?.layer.rasterizationScale = UIScreen.main.scale
//                times -= 1
//            }
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named : "map"), for: .normal)
            let btn2 = UIButton()
            btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            btn2.setImage(UIImage(named : "map"), for: .normal)
            annotationView?.rightCalloutAccessoryView = btn
            //annotationView?.leftCalloutAccessoryView = btn2
        }
        return annotationView
    }
        
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapViewStory.centerCoordinate.latitude, longitude: mapViewStory.centerCoordinate.longitude)
        showSightingonMap(location: location, filter: selectedPoke)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.leftCalloutAccessoryView){
            print("Left")
        }
        if let anno = view.annotation as? PokeAnnotation{
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            destination.name = "Pokemon Sighting"
            let regiondistance : CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regiondistance, regiondistance)
            let option  = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate : regionSpan.center),MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan : regionSpan.span),MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            MKMapItem.openMaps(with: [destination], launchOptions: option)
        }
        
        // Open google Map
//        UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=Google+Inc,+8th+Avenue,+New+York,+NY&daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York&directionsmode=transit")!)
    }
}

extension ViewController : PokeListVCDelegate{
    func getSelelctedPokemon(pokemons: [Int]) {
        print(pokemons)
        self.mapViewStory.removeAnnotations(mapViewStory.annotations)
        self.selectedPoke = pokemons
        guard let location = mapViewStory.userLocation.location else {return}
        self.showSightingonMap(location: location, filter: selectedPoke)
    }
    
    func didSelectPokemon(number: Int) {
        guard let location = mapViewStory.userLocation.location else {return}
        createSighting(forlocation: location, withPokemon: number)
    }
}


