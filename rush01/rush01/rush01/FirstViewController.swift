//
//  FirstViewController.swift
//  rush01
//
//  Created by Marc FAMILARI on 10/14/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBAction func localisationAction(_ sender: UIButton) {
        if let location = self.userLocation {
            self.centerAndZoom(location)
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var resultSearchController: UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request authorization
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        
        // Set UISearchController
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        self.resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        self.resultSearchController?.hidesNavigationBarDuringPresentation = false
        self.resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
        
        // Zoom on user location on launch
        if let location = self.locationManager.location {
            self.centerAndZoom(location)
        }
    }
    
    func traceRoute(sourceLoc: CLPlacemark, destLoc: CLPlacemark) {
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        var sourcePlace: MKPlacemark?
        var destPlace: MKPlacemark?
        
        
        if let adressDict = sourceLoc.addressDictionary, let coordinate = sourceLoc.location?.coordinate {
            sourcePlace = MKPlacemark(coordinate: coordinate, addressDictionary: adressDict as? [String : Any])
        }
        
        if let adressDict = destLoc.addressDictionary, let coordinate = destLoc.location?.coordinate {
            destPlace = MKPlacemark(coordinate: coordinate, addressDictionary: adressDict as? [String : Any])
        }
        
        if sourcePlace == nil || destPlace == nil { return }
        
        let sourceMapItem = MKMapItem(placemark: sourcePlace!)
        let destinationMapItem = MKMapItem(placemark: destPlace!)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = sourceMapItem.placemark.name
        if let city = sourceMapItem.placemark.locality, let admArea =  sourceMapItem.placemark.administrativeArea {
            sourceAnnotation.subtitle = "\(city) (\(admArea))"
        }
        
        if let location = sourceLoc.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = destinationMapItem.placemark.name
        if let city = destinationMapItem.placemark.locality, let admArea =  destinationMapItem.placemark.administrativeArea {
            destinationAnnotation.subtitle = "\(city) (\(admArea))"
        }
        
        if let location = destLoc.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func centerAndZoom(_ location: CLLocation) {
        let locationCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locationCoordinate, 1500, 1500), animated: true)
    }
    
    
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = manager.location
    }
    
    
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    @IBAction func selectMode(_ sender: Any) {
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

extension FirstViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        self.selectedPin = placemark
        // clear existing pins
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(\(city)) (\(state))"
        }
        self.mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        self.mapView.setRegion(region, animated: true)
    }
}

