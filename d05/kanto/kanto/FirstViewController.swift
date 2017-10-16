//
//  FirstViewController.swift
//  kanto
//
//  Created by Martin SIREAU on 10/9/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var locationManager = CLLocationManager()
    
    var locValue = CLLocationCoordinate2D()
    let span = MKCoordinateSpan(latitudeDelta: 0.0045, longitudeDelta: 0.0045)
    var mkCoor = MKCoordinateRegion()
    
    var allPin = [PinAnnotation]()

    override func viewWillAppear(_ animated: Bool) {
        let mkcoor2 = MKCoordinateRegion(center: Singleton.shared.selectedPlace.coor, span: span)
        mapView.setRegion(mkcoor2, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cll = CLLocationCoordinate2D(latitude: 48.896447, longitude: 2.318554)
        let span = MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        let mkCoor = MKCoordinateRegion(center: cll, span: span)

        let place1 = Places(name: "42", description: "Ecole trop Stylée", coor: CLLocationCoordinate2D(latitude: 48.896447, longitude: 2.318554))
        let place2 = Places(name: "Lyon", description: "Ville de Lyon", coor: CLLocationCoordinate2D(latitude: 45.764058, longitude: 4.830829))
        let place3 = Places(name: "Nantes", description: "Ville de Nantes", coor: CLLocationCoordinate2D(latitude: 47.222347, longitude: -1.541861))
        let place4 = Places(name: "San Fransisco", description: "SF City", coor: CLLocationCoordinate2D(latitude: 37.763379, longitude: -122.453394))
        let place5 = Places(name: "Full Moon", description: "Junk food", coor: CLLocationCoordinate2D(latitude: 48.895592, longitude: 2.317249))
        
        Singleton.shared.allPlaces.append(place1)
        Singleton.shared.allPlaces.append(place2)
        Singleton.shared.allPlaces.append(place3)
        Singleton.shared.allPlaces.append(place4)
        Singleton.shared.allPlaces.append(place5)
        
        self.createPin()
        
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        
        mapView.setRegion(mkCoor, animated: true)
    }

    @IBAction func locateMe(_ sender: Any) {
        mapView.setRegion(mkCoor, animated: true)
    }
    
    func getColor(place:String?) -> UIColor {
        switch place! {
        case "42":
            return UIColor.blue
        case "Lyon":
            return UIColor.yellow
        case "Nantes":
            return UIColor.green
        case "San Fransisco":
            return UIColor.magenta
        case "Full Moon":
            return UIColor.black
        default:
            return UIColor.red
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            var annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            let reuseID = "pin"
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView.pinTintColor = getColor(place: annotation.title!)
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
    
    func createPin(){
        for place in Singleton.shared.allPlaces{
            let pin = PinAnnotation(title: place.name, subtitle: place.desc, coordinate: place.coor)
            allPin.append(pin)
            mapView.addAnnotation(pin)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        mkCoor = MKCoordinateRegion(center: locValue, span: span)

        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        mapView.setRegion(mkCoor, animated: true)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            print("default")
        }
    }
    
}

